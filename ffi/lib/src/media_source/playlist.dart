// ignore_for_file: comment_references

import '../enums/media_source_type.dart';
import '../enums/playlist_mode.dart';
import 'media.dart';
import 'media_source.dart';

/// A playlist object to open inside a [Player.open].
///
/// Takes [List] of [Media] as parameter to open inside the [Player] instance, for playing sequencially.
///
/// ```dart
/// new Playlist(
///   medias: [
///     Media.file(
///       new File('C:/music.mp3'),
///     ),
///     Media.network(
///       'https://alexmercerind.github.io/music.mp3',
///     ),
///     Media.file(
///       new File('C:/audio.mp3'),
///     ),
///   ],
/// );
/// ```
///
class Playlist extends MediaSource {
  const Playlist({
    required this.medias,
    this.playlistMode = PlaylistMode.single,
  }) : super(mediaSourceType: MediaSourceType.playlist);

  /// [List] of [Media] present in the playlist.
  final List<Media> medias;
  final PlaylistMode playlistMode;

  @override
  String toString() => 'Playlist[${medias.length}]';

  @override
  List<Object?> get props => [mediaSourceType, playlistMode, medias];
}
