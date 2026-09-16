import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/location_selection_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/shimmer/homescreen_shimmer.dart';
import 'package:hoodz/features/user/homescreen/presentation/controllers/home_screen_controller.dart';
import 'package:http/http.dart' as http;
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
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  late LatLng mapCenter;
  late LocationAddress selectedLocation;

  bool isResolvingAddress = false;
  bool isMovingToCurrentLocation = false;
  bool isSearchingAddress = false;
  List<_MapSearchSuggestion> searchSuggestions = const [];
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    selectedLocation = LocationSelectionService.fallbackLocation;
    mapCenter = LatLng(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        isSearchingAddress = false;
        searchSuggestions = const [];
      });
      return;
    }

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () => _searchAddress(query),
    );
  }

  Future<void> _searchAddress(String query) async {
    final requestId = ++_searchRequestId;
    setState(() => isSearchingAddress = true);

    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'jsonv2',
          'addressdetails': '1',
          'limit': '5',
        },
      );
      final response = await http.get(
        uri,
        headers: const {
          'User-Agent': 'hoodz-app',
        },
      );

      if (!mounted || requestId != _searchRequestId) {
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          isSearchingAddress = false;
          searchSuggestions = const [];
        });
        return;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        setState(() {
          isSearchingAddress = false;
          searchSuggestions = const [];
        });
        return;
      }

      setState(() {
        isSearchingAddress = false;
        searchSuggestions = decoded
            .whereType<Map<String, dynamic>>()
            .map(_MapSearchSuggestion.fromJson)
            .whereType<_MapSearchSuggestion>()
            .toList(growable: false);
      });
    } catch (_) {
      if (mounted && requestId == _searchRequestId) {
        setState(() {
          isSearchingAddress = false;
          searchSuggestions = const [];
        });
      }
    }
  }

  void _selectSearchSuggestion(_MapSearchSuggestion suggestion) {
    final target = LatLng(suggestion.latitude, suggestion.longitude);
    searchFocusNode.unfocus();
    searchController.text = suggestion.title;
    mapController.move(target, 16);
    setState(() {
      mapCenter = target;
      searchSuggestions = const [];
      selectedLocation = LocationAddress(
        label: suggestion.title,
        addressLine: suggestion.subtitle,
        latitude: suggestion.latitude,
        longitude: suggestion.longitude,
        country: suggestion.country,
      );
    });
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
        Strings.locationUnavailable.tr,
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
    searchFocusNode.unfocus();
    setState(() {
      mapCenter = point;
      isResolvingAddress = true;
      searchSuggestions = const [];
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
                      Strings.deliveryAddress.tr,
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
                    left: 16.w(context),
                    right: 16.w(context),
                    top: 16.h(context),
                    child: _MapSearchBox(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      suggestions: searchSuggestions,
                      isSearching: isSearchingAddress,
                      onChanged: _onSearchChanged,
                      onTapSuggestion: _selectSearchSuggestion,
                    ),
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
                                  child: const HomeShimmerBox(
                                    height: 18,
                                    width: 18,
                                    radius: 9,
                                    circle: true,
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
                          const HomeShimmerBox(
                            height: 14,
                            width: 14,
                            radius: 7,
                            circle: true,
                          ),
                          SizedBox(width: 8.w(context)),
                          Text(
                            Strings.updatingSelectedAddress.tr,
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
                          Get.find<HomeScreenController>()
                              .updateSelectedLocation(selectedLocation);
                        }
                        Navigator.pop(context, selectedLocation);
                      },
                      child: Text(
                        Strings.confirmPinLocation.tr,
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

class _MapSearchBox extends StatelessWidget {
  const _MapSearchBox({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.isSearching,
    required this.onChanged,
    required this.onTapSuggestion,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<_MapSearchSuggestion> suggestions;
  final bool isSearching;
  final ValueChanged<String> onChanged;
  final ValueChanged<_MapSearchSuggestion> onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search location',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF7A7A7A),
                ),
                suffixIcon: isSearching
                    ? Padding(
                        padding: EdgeInsets.all(14.r(context)),
                        child: SizedBox(
                          width: 16.w(context),
                          height: 16.w(context),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF6A00),
                          ),
                        ),
                      )
                    : controller.text.trim().isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              controller.clear();
                              onChanged('');
                            },
                            icon: const Icon(Icons.close_rounded),
                            color: const Color(0xFF7A7A7A),
                          ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w(context),
                  vertical: 14.h(context),
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF333333),
                    fontSize: 14.sp(context),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (suggestions.isNotEmpty) ...[
              const Divider(height: 1, color: Color(0xFFEDEDED)),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 230.h(context)),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFEDEDED),
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return InkWell(
                      onTap: () => onTapSuggestion(suggestion),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w(context),
                          vertical: 11.h(context),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20.sp(context),
                              color: const Color(0xFF6F6F6F),
                            ),
                            SizedBox(width: 10.w(context)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF333333),
                                          fontSize: 13.sp(context),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(height: 2.h(context)),
                                  Text(
                                    suggestion.subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF8A8A8A),
                                          fontSize: 11.sp(context),
                                          height: 1.3,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MapSearchSuggestion {
  const _MapSearchSuggestion({
    required this.title,
    required this.subtitle,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String subtitle;
  final String country;
  final double latitude;
  final double longitude;

  static _MapSearchSuggestion? fromJson(Map<String, dynamic> json) {
    final latitude = double.tryParse(json['lat']?.toString() ?? '');
    final longitude = double.tryParse(json['lon']?.toString() ?? '');
    final displayName = json['display_name']?.toString().trim() ?? '';

    if (latitude == null || longitude == null || displayName.isEmpty) {
      return null;
    }

    final parts = displayName
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final address = json['address'];
    final country = address is Map<String, dynamic>
        ? address['country']?.toString().trim()
        : null;

    return _MapSearchSuggestion(
      title: parts.isEmpty ? displayName : parts.first,
      subtitle: parts.length > 1 ? parts.skip(1).join(', ') : displayName,
      country: country?.isNotEmpty == true ? country! : 'Bangladesh',
      latitude: latitude,
      longitude: longitude,
    );
  }
}
