// ignore_for_file: comment_references

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import '../enums/media_type.dart';
import '../internal/ffi.dart';
import 'media_source.dart';

/// A media object to open inside a [Player].
///
/// Pass `true` to [parse] for retrieving the metadata of the [Media].
/// [timeout] sets the time-limit for retriveing metadata.
/// [Media.metas] can be then, accessed to get the retrived metadata as `Map<String, String>`.
///
/// * A [Media] from a [File].
///
/// ```dart
/// Media media = Media.file(File('C:/music.ogg'));
/// ```
///
/// * A [Media] from a [Uri].
///
/// ```dart
/// Media media = Media.network('http://alexmercerind.github.io/music.mp3');
/// ```
///
/// For starting a [Media] at particular time, one can pass `startTime`.
///
/// ```dart
/// Media media = Media.file(
///   File('C:/music.ogg'),
///   startTime: Duration(milliseconds: 20),
/// );
/// ```
///
class Media extends MediaSource {
  Media._({
    required this.mediaType,
    required this.resource,
    required this.metas,
    this.startTime = Duration.zero,
    this.stopTime = Duration.zero,
    bool parse = false,
    Duration? timeout,
  }) {
    if (parse && timeout != null) {
      this.parse(timeout);
    }
  }

  /// Makes [Media] object from a [File].
  Media.file(
    File file, {
    bool parse = false,
    Duration timeout = const Duration(seconds: 10),
    Duration startTime = Duration.zero,
    Duration stopTime = Duration.zero,
  }) : this._(
          mediaType: MediaType.file,
          resource: file.path,
          metas: {},
          startTime: startTime,
          stopTime: stopTime,
          timeout: timeout,
          parse: parse,
        );

  /// Makes [Media] object from url.
  Media.network(
    dynamic url, {
    bool parse = false,
    Duration timeout = const Duration(seconds: 10),
    Duration startTime = Duration.zero,
    Duration stopTime = Duration.zero,
  }) : this._(
          mediaType: MediaType.network,
          resource: '$url',
          metas: {},
          startTime: startTime,
          stopTime: stopTime,
          parse: parse,
          timeout: timeout,
        );

  /// Makes [Media] object from direct show.
  Media.directShow({
    String? rawUrl,
    Map<String, dynamic>? args,
    String? vdev,
    String? adev,
    int? liveCaching,
  }) : this._(
          mediaType: MediaType.directShow,
          resource: rawUrl ??
              _buildDirectShowUrl(
                args ??
                    <String, dynamic>{
                      'dshow-vdev': vdev,
                      'dshow-adev': adev,
                      'live-caching': liveCaching,
                    },
              ),
          metas: {},
        );

  /// Makes [Media] object from assets.
  ///
  /// **WARNING**
  ///
  /// This method only works for Flutter.
  /// Might result in an exception on Dart CLI.
  ///
  factory Media.asset(
    String asset, {
    Duration startTime = Duration.zero,
  }) {
    String? assetPath;
    if (Platform.isWindows || Platform.isLinux) {
      assetPath = path.join(
        path.dirname(Platform.resolvedExecutable),
        'data',
        'flutter_assets',
        asset,
      );
    } else if (Platform.isMacOS) {
      assetPath = path.join(
        path.dirname(Platform.resolvedExecutable),
        '..',
        'Frameworks',
        'App.framework',
        'Resources',
        'flutter_assets',
        asset,
      );
    } else if (Platform.isIOS) {
      assetPath = path.join(
        path.dirname(Platform.resolvedExecutable),
        'Frameworks',
        'App.framework',
        'flutter_assets',
        asset,
      );
    }
    if (assetPath == null) {
      throw UnimplementedError('The platform is not supported');
    }
    final url = Uri.file(assetPath, windows: Platform.isWindows);
    return Media._(
      mediaType: MediaType.asset,
      resource: url.toString(),
      metas: {},
      startTime: startTime,
    );
  }
  // @override
  // MediaSourceType get mediaSourceType => MediaSourceType.media;
  final MediaType mediaType;
  final String resource;
  final Duration startTime;
  final Duration stopTime;
  final Map<String, String> metas;

  /// Parses the [Media] to retrieve [Media.metas].
  void parse(Duration timeout) {
    final mediaTypeCStr = mediaType.toString().toNativeUtf8();
    final resourceCStr = resource.toNativeUtf8();
    final parsedMetas = MediaFFI.parse(
      this,
      mediaTypeCStr,
      resourceCStr,
      timeout.inMilliseconds,
    );
    calloc
      ..free(mediaTypeCStr)
      ..free(resourceCStr);

    // Keep this sorted alphabetically by key.
    metas.addAll({
      'actors': parsedMetas.elementAt(0).value.toDartString(),
      'album': parsedMetas.elementAt(1).value.toDartString(),
      'albumArtist': parsedMetas.elementAt(2).value.toDartString(),
      'artist': parsedMetas.elementAt(3).value.toDartString(),
      'artworkUrl': parsedMetas.elementAt(4).value.toDartString(),
      'copyright': parsedMetas.elementAt(5).value.toDartString(),
      'date': parsedMetas.elementAt(6).value.toDartString(),
      'description': parsedMetas.elementAt(7).value.toDartString(),
      'director': parsedMetas.elementAt(8).value.toDartString(),
      'discNumber': parsedMetas.elementAt(9).value.toDartString(),
      'discTotal': parsedMetas.elementAt(10).value.toDartString(),
      'duration': parsedMetas.elementAt(11).value.toDartString(),
      'encodedBy': parsedMetas.elementAt(12).value.toDartString(),
      'episode': parsedMetas.elementAt(13).value.toDartString(),
      'genre': parsedMetas.elementAt(14).value.toDartString(),
      'language': parsedMetas.elementAt(15).value.toDartString(),
      'nowPlaying': parsedMetas.elementAt(16).value.toDartString(),
      'rating': parsedMetas.elementAt(17).value.toDartString(),
      'season': parsedMetas.elementAt(18).value.toDartString(),
      'settings': parsedMetas.elementAt(19).value.toDartString(),
      'title': parsedMetas.elementAt(20).value.toDartString(),
      'trackNumber': parsedMetas.elementAt(21).value.toDartString(),
      'trackTotal': parsedMetas.elementAt(22).value.toDartString(),
      'url': parsedMetas.elementAt(23).value.toDartString(),
    });
  }

  static String _buildDirectShowUrl(Map<String, dynamic> args) {
    return args.entries.fold(
      'dshow://',
      (prev, pair) =>
          prev +
          (pair.value != null
              ? ' :${pair.key.toLowerCase()}=${pair.value}'
              : ''),
    );
  }

  @override
  String toString() => '[$mediaType]$resource';

  @override
  List<Object?> get props => [];
}

extension DurationExtension on Duration {
  String argument(String value) => this == Duration.zero
      ? ''
      : ':$value=${(inMilliseconds / 1000).toStringAsFixed(6)}';
}
