import 'package:ffi/ffi.dart';

import 'internal/ffi.dart';
import 'media_source/media.dart';

/// Internally used class to avoid direct creation of the object of a [Chromecast] class.
class _Chromecast extends Chromecast {}

class Chromecast {
  /// ID for this [Chromecast].
  late int id;

  /// Chromecast [Media].
  late Media media;

  /// IP address of your chromecast e.g. `192.168.1.XXX`.
  late String ipAddress;

  /// Creates a new [Chromecast] instance.
  static Future<Chromecast> create({
    required int id,
    required Media media,
    required String ipAddress,
  }) async {
    final Chromecast chromecast = _Chromecast()
      ..id = id
      ..media = media
      ..ipAddress = ipAddress;
    final mediaTypeCStr = media.mediaType.toString().toNativeUtf8();
    final mediaResourceCStr = media.resource.toNativeUtf8();
    final ipAddressCStr = ipAddress.toNativeUtf8();
    ChromecastFFI.create(
      id,
      mediaTypeCStr,
      mediaResourceCStr,
      ipAddressCStr,
    );
    calloc
      ..free(mediaTypeCStr)
      ..free(mediaResourceCStr)
      ..free(ipAddressCStr);
    return chromecast;
  }

  /// Start sending [Media] content to chromecast
  void start() {
    ChromecastFFI.start(id);
  }

  /// Disposes this instance of [Chromecast].
  void dispose() {
    ChromecastFFI.dispose(id);
  }
}
