import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:hoodz/core/services/network_caller/network_caller.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:hoodz/urls.dart';

class ReferralService {
  ReferralService(this._networkCaller);

  static const String referralHost = 'the-hoodz-7a518.web.app';
  static const String referralPathPrefix = '/ref/';

  final NetworkCaller _networkCaller;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  bool _started = false;

  String buildReferralLink(String referralCode) {
    return 'https://$referralHost$referralPathPrefix${Uri.encodeComponent(referralCode)}';
  }

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (_) {},
    );
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleUri(initialUri);
      }
    } catch (_) {
      // A missing or malformed initial link must not interrupt app startup.
    }
  }

  Future<void> _handleUri(Uri uri) async {
    final referralCode = _extractReferralCode(uri);
    if (referralCode == null) return;

    final accessToken = MySharedPref.getAccessToken();
    if (accessToken?.trim().isNotEmpty == true) {
      final response = await _networkCaller.postRequest(
        Urls.referralCodeUrl,
        body: {'referralCode': referralCode},
        accessToken: accessToken,
      );
      if (response.isSuccess) {
        await MySharedPref.clearPendingReferralCode();
      }
      return;
    }

    await MySharedPref.setPendingReferralCode(referralCode);
  }

  String? _extractReferralCode(Uri uri) {
    if (uri.host != referralHost) return null;

    final path = uri.path;
    if (!path.startsWith(referralPathPrefix)) return null;

    final code = path.substring(referralPathPrefix.length).trim();
    return code.isEmpty ? null : Uri.decodeComponent(code);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
