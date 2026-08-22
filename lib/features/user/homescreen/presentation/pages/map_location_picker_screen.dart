import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:latlong2/latlong.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  final LocationSelectionService locationService =
      Get.find<LocationSelectionService>();
  final MapController mapController = MapController();

  late LatLng mapCenter;
  late LocationAddress selectedLocation;

  bool isResolvingAddress = false;
  bool isMovingToCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    selectedLocation = LocationSelectionService.fallbackLocation;
    mapCenter = LatLng(selectedLocation.latitude, selectedLocation.longitude);
  }

  Future<void> _moveToCurrentLocation() async {
    setState(() => isMovingToCurrentLocation = true);
    try {
      final current = await locationService.getCurrentLocation();
      final target = LatLng(current.latitude, current.longitude);
      mapController.move(target, 16);
      if (!mounted) {
        return;
      }
      setState(() {
        mapCenter = target;
        selectedLocation = current;
      });
    } on LocationServiceException catch (error) {
      Get.snackbar(
        'Location unavailable',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() => isMovingToCurrentLocation = false);
      }
    }
  }

  Future<void> _selectLocation(LatLng point) async {
    setState(() {
      mapCenter = point;
      isResolvingAddress = true;
    });
    final resolved = await locationService.getAddressFromCoordinates(
      latitude: point.latitude,
      longitude: point.longitude,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      selectedLocation = resolved;
      isResolvingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w(context),
                10.h(context),
                16.w(context),
                12.h(context),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 36.h(context),
                      width: 36.w(context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFEFEFEF)),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp(context),
                        color: const Color(0xFF676767),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w(context)),
                  Expanded(
                    child: Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF333333),
                        fontSize: 18.sp(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: mapCenter,
                      initialZoom: 16,
                      onTap: (_, point) {
                        _selectLocation(point);
                      },
                      onPositionChanged: (position, hasGesture) {
                        final center = position.center;
                        if (center != null) {
                          mapCenter = center;
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.hoodz',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              selectedLocation.latitude,
                              selectedLocation.longitude,
                            ),
                            width: 56.w(context),
                            height: 56.h(context),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 40.sp(context),
                              color: const Color(0xFFFF6A00),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 16.w(context),
                    bottom: 154.h(context),
                    child: InkWell(
                      onTap: isMovingToCurrentLocation
                          ? null
                          : _moveToCurrentLocation,
                      child: Container(
                        height: 44.h(context),
                        width: 44.w(context),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isMovingToCurrentLocation
                              ? SizedBox(
                                  height: 18.h(context),
                                  width: 18.w(context),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.my_location_rounded,
                                  size: 20.sp(context),
                                  color: const Color(0xFF353535),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                16.w(context),
                14.h(context),
                16.w(context),
                20.h(context),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color(0xFF8D8D8D),
                        size: 20.sp(context),
                      ),
                      SizedBox(width: 8.w(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedLocation.country,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xFF4A4A4A),
                                    fontSize: 14.sp(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 2.h(context)),
                            Text(
                              selectedLocation.fullAddress,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xFF8B8B8B),
                                    fontSize: 12.sp(context),
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h(context)),
                  if (isResolvingAddress)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h(context)),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 14.h(context),
                            width: 14.w(context),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 8.w(context)),
                          Text(
                            'Updating selected address...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF8B8B8B),
                                  fontSize: 12.sp(context),
                                ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6A00),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r(context)),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (Get.isRegistered<HomeScreenController>()) {
                          Get.find<HomeScreenController>().updateSelectedLocation(
                            selectedLocation,
                          );
                        }
                        Navigator.pop(context, selectedLocation);
                      },
                      child: Text(
                        'Confirm pin location',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 15.sp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
