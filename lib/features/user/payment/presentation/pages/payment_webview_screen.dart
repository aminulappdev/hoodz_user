import 'package:flutter/material.dart';
import 'package:hoodz/core/widgets/shimmer/payment_shimmer.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.returnUrl,
    this.onPaymentCompleted,
  });

  final String paymentUrl;
  final String? returnUrl;
  final VoidCallback? onPaymentCompleted;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _handledCompletion = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
            _checkForCompletion();
          },
          onUrlChange: (change) {
            final url = change.url;
            if (url != null && url.isNotEmpty) {
              _tryCompleteFromUrl(url);
            }
          },
          onNavigationRequest: (request) {
            _tryCompleteFromUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _checkForCompletion() async {
    final currentUrl = await _controller.currentUrl();
    if (currentUrl != null && currentUrl.isNotEmpty) {
      _tryCompleteFromUrl(currentUrl);
    }
  }

  void _tryCompleteFromUrl(String url) {
    if (_handledCompletion) {
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    final isReturnPage = _matchesReturnUrl(uri);
    final isSuccess = _isSuccessfulReturn(uri);

    if (!isReturnPage || !isSuccess) {
      return;
    }

    _handledCompletion = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      widget.onPaymentCompleted?.call();
    });
  }

  bool _matchesReturnUrl(Uri uri) {
    final returnUrl = widget.returnUrl;
    if (returnUrl == null || returnUrl.isEmpty) {
      return uri.path.contains('/payments/paymob/return');
    }

    final normalizedReturn = _normalizeUrl(returnUrl);
    final normalizedCurrent = _normalizeUrl(uri.toString());

    return normalizedCurrent.startsWith(normalizedReturn) ||
        uri.path.contains('/payments/paymob/return');
  }

  bool _isSuccessfulReturn(Uri uri) {
    final success = uri.queryParameters['success']?.toLowerCase() == 'true';
    final txnApproved =
        uri.queryParameters['txn_response_code']?.toUpperCase() == 'APPROVED';
    final messageApproved =
        uri.queryParameters['data.message']?.toLowerCase() == 'approved';

    return success || txnApproved || messageApproved;
  }

  String _normalizeUrl(String url) {
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Strings.securePayment.tr),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: const PaymentShimmerBox(
                height: 3,
                width: double.infinity,
                radius: 0,
              ),
            ),
        ],
      ),
    );
  }
}
