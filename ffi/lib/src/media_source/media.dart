// ignore_for_file: comment_references

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import '../enums/media_source_type.dart';
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
  const Media._({
    required this.mediaType,
    required this.resource,
    required this.metas,
    this.startTime = Duration.zero,
    this.stopTime = Duration.zero,
  }) : super(mediaSourceType: MediaSourceType.media);

  /// Makes [Media] object from a [File].
  factory Media.file(
    File file, {
    bool parse = false,
    Duration timeout = const Duration(seconds: 10),
    Duration startTime = Duration.zero,
    Duration stopTime = Duration.zero,
  }) {
    final media = Media._(
      mediaType: MediaType.file,
      resource: file.path,
      metas: const {},
      startTime: startTime,
      stopTime: stopTime,
    );
    if (parse) {
      media.parse(timeout);
    }
    return media;
  }

  /// Makes [Media] object from url.
  factory Media.network(
    dynamic url, {
    bool parse = false,
    Duration timeout = const Duration(seconds: 10),
    Duration startTime = Duration.zero,
    Duration stopTime = Duration.zero,
  }) {
    final media = Media._(
      mediaType: MediaType.network,
      resource: '$url',
      metas: const {},
      startTime: startTime,
      stopTime: stopTime,
    );
    if (parse) {
      media.parse(timeout);
    }
    return media;
  }

  /// Makes [Media] object from direct show.
  factory Media.directShow({
    String? rawUrl,
    Map<String, dynamic>? args,
    String? vdev,
    String? adev,
    int? liveCaching,
  }) {
    final resourceUrl = rawUrl ??
        _buildDirectShowUrl(
          args ??
              <String, dynamic>{
                'dshow-vdev': vdev,
                'dshow-adev': adev,
                'live-caching': liveCaching
              },
        );

    return Media._(
      mediaType: MediaType.directShow,
      resource: resourceUrl,
      metas: const {},
    );
  }

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
      metas: const {},
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
    final metas = MediaFFI.parse(
      this,
      mediaTypeCStr,
      resourceCStr,
      timeout.inMilliseconds,
    );
    calloc
      ..free(mediaTypeCStr)
      ..free(resourceCStr);
    // Keep this sorted alphabetically by key.
    this.metas['actors'] = metas.elementAt(0).value.toDartString();
    this.metas['album'] = metas.elementAt(1).value.toDartString();
    this.metas['albumArtist'] = metas.elementAt(2).value.toDartString();
    this.metas['artist'] = metas.elementAt(3).value.toDartString();
    this.metas['artworkUrl'] = metas.elementAt(4).value.toDartString();
    this.metas['copyright'] = metas.elementAt(5).value.toDartString();
    this.metas['date'] = metas.elementAt(6).value.toDartString();
    this.metas['description'] = metas.elementAt(7).value.toDartString();
    this.metas['director'] = metas.elementAt(8).value.toDartString();
    this.metas['discNumber'] = metas.elementAt(9).value.toDartString();
    this.metas['discTotal'] = metas.elementAt(10).value.toDartString();
    this.metas['duration'] = metas.elementAt(11).value.toDartString();
    this.metas['encodedBy'] = metas.elementAt(12).value.toDartString();
    this.metas['episode'] = metas.elementAt(13).value.toDartString();
    this.metas['genre'] = metas.elementAt(14).value.toDartString();
    this.metas['language'] = metas.elementAt(15).value.toDartString();
    this.metas['nowPlaying'] = metas.elementAt(16).value.toDartString();
    this.metas['rating'] = metas.elementAt(17).value.toDartString();
    this.metas['season'] = metas.elementAt(18).value.toDartString();
    this.metas['settings'] = metas.elementAt(19).value.toDartString();
    this.metas['title'] = metas.elementAt(20).value.toDartString();
    this.metas['trackNumber'] = metas.elementAt(21).value.toDartString();
    this.metas['trackTotal'] = metas.elementAt(22).value.toDartString();
    this.metas['url'] = metas.elementAt(23).value.toDartString();
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
