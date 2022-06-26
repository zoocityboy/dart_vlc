/// Enum to specify the type of `MediaSource` passed in [Player.open].
// ignore_for_file: comment_references

enum MediaSourceType {
  /// A single `Media`.
  media,

  /// A `Playlist` containing multiple `Media` to play sequencially.
  playlist,
}
