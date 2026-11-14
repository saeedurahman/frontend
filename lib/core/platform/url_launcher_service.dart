import 'package:url_launcher/url_launcher.dart';

/// Opens web links, mailto, tel, or wa.me URLs.
abstract class UrlLauncherService {
  Future<bool> launch(Uri uri, {bool externalApplication = true});
}

class WindowsUrlLauncherService implements UrlLauncherService {
  const WindowsUrlLauncherService();

  @override
  Future<bool> launch(Uri uri, {bool externalApplication = true}) {
    return launchUrl(
      uri,
      mode: externalApplication
          ? LaunchMode.externalApplication
          : LaunchMode.platformDefault,
    );
  }
}
