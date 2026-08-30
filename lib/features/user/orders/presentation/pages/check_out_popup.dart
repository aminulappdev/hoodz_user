import 'dart:async';
import 'package:flutter/material.dart';

const Color kOrange = Color(0xFFE8622C);

// ============================================================================
// DATA MODEL
// ============================================================================
class OrderItem {
  final String name;
  final String size;
  final int quantity;
  final double price;
  final String? imageUrl; // nullable — falls back to a placeholder icon

  const OrderItem({
    required this.name,
    required this.size,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });
}

// ============================================================================
// PUBLIC ENTRY POINT
// ============================================================================
// Why a top-level function instead of just calling showModalBottomSheet
// directly inside CheckoutScreen? -> This keeps ALL the sheet's config
// (shape, isScrollControlled, barrier behaviour) in ONE place. Any screen
// that wants this exact popup calls `showConfirmOrderSheet(...)` and can't
// accidentally forget `isScrollControlled: true` or get the rounded-corner
// shape wrong. This is the same reasoning as extracting a widget class —
// just applied to a function that triggers UI instead of a widget that
// renders it.
// ============================================================================
  Future<void> showConfirmOrderSheet(
  BuildContext context, {
  required String deliveryAddress,
  required List<OrderItem> items,
  required VoidCallback onContinue,
  required VoidCallback onEditOrder,
  int secondsToConfirm = 15,
}) {
  return showModalBottomSheet(
    context: context,
    // Default bottom sheets snap to ~half the screen height and refuse to
    // grow. Our content (items list + summary) needs more room than that,
    // so isScrollControlled: true lets the sheet size itself to its
    // content (up to full screen) instead of being capped.
    isScrollControlled: true,
    // A modal bottom sheet MUST be dismissible in some way, but we don't
    // want an accidental outside-tap to lose the user's order confirmation
    // context — so we disable tap-outside-to-close and only let our own
    // buttons close it.
    isDismissible: false,
    enableDrag: false,
    backgroundColor:
        Colors.transparent, // the sheet itself draws its own rounded card
    builder: (context) {
      return ConfirmOrderSheet(
        deliveryAddress: deliveryAddress,
        items: items,
        secondsToConfirm: secondsToConfirm,
        onContinue: onContinue,
        onEditOrder: onEditOrder,
      );
    },
  );
}

// ============================================================================
// ConfirmOrderSheet
// ============================================================================
class ConfirmOrderSheet extends StatefulWidget {
  final String deliveryAddress;
  final List<OrderItem> items;
  final int secondsToConfirm;
  final VoidCallback onContinue;
  final VoidCallback onEditOrder;

  const ConfirmOrderSheet({
    super.key,
    required this.deliveryAddress,
    required this.items,
    required this.onContinue,
    required this.onEditOrder,
    this.secondsToConfirm = 15,
  });

  @override
  State<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends State<ConfirmOrderSheet> {
  late int _secondsLeft = widget.secondsToConfirm;
  Timer? _timer;
  bool get _canContinue => _secondsLeft <= 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Timer.periodic fires the callback repeatedly every `duration`.
    // We store the returned Timer in `_timer` so we can cancel it later —
    // Timer.periodic never stops on its own, it runs forever unless you
    // cancel it yourself.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() => _secondsLeft = 0);
        }
        return;
      }
      // setState is what makes the "00:58 -> 00:57" text actually repaint.
      // Without it, _secondsLeft would change in memory but the UI would
      // stay frozen on the old number.
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    // CRITICAL: cancel the timer when this widget is removed from the
    // tree (sheet closed). If we forget this, the timer keeps firing,
    // calls setState() on a State object that no longer exists, and
    // Flutter throws: "setState() called after dispose()".
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int get _totalQuantity =>
      widget.items.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    // Clamp the sheet's max height so it never overflows the screen on
    // small devices, while still letting it hug its content when the
    // content is short.
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      // Padding.only + MediaQuery viewInsets.bottom would matter if this
      // sheet had a TextField (keyboard push-up). It doesn't here, so a
      // flat padding is enough — but it's worth remembering for later.
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          const Text( 
            'Confirm Your Order',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Please review your order before placing it.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _DeliveryAddressRow(address: widget.deliveryAddress),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Text(
                _totalQuantity.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) =>
                  OrderItemTile(item: widget.items[index]),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onEditOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kOrange,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Edit order $_formattedTime',
                    style: const TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canContinue ? widget.onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// _DeliveryAddressRow — private, sheet-specific
// ============================================================================
// Why NOT reuse your existing InfoRowCard here? Look closely at the design:
// InfoRowCard renders a white card WITH ITS OWN shadow/background (it wraps
// DeliveryCardContainer). Inside this sheet, the row sits directly on the
// sheet's white background with no card/shadow of its own — visually a
// different component, even though the icon+title+subtitle idea is similar.
// Forcing InfoRowCard in here would mean fighting its built-in styling.
// Lesson: reuse when the VISUAL contract matches, not just when the data
// shape happens to match.
// ============================================================================
class _DeliveryAddressRow extends StatelessWidget {
  final String address;

  const _DeliveryAddressRow({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.location_on_outlined,
            size: 20,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 3),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// OrderItemTile — public, reusable (cart screen / order history could use it too)
// ============================================================================
class OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.imageUrl != null
              ? Image.network(
                  item.imageUrl!,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  // errorBuilder handles a broken/failed network image
                  // gracefully instead of showing Flutter's default red
                  // error box — always good practice for user-facing UI.
                  errorBuilder: (_, __, ___) => _placeholderThumb(),
                )
              : _placeholderThumb(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Size: ${item.size}     Quantity: ${item.quantity}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Text(
          '\$${item.price.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _placeholderThumb() {
    return Container(
      width: 52,
      height: 52,
      color: const Color(0xFFF1F1F3),
      child: const Icon(Icons.checkroom, size: 22, color: Colors.black26),
    );
  }
}
