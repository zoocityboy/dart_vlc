import 'package:equatable/equatable.dart';

import '../enums/media_source_type.dart';

/// Parent abstract class of `Media` and `Playlist`.
abstract class MediaSource extends Equatable {
  const MediaSource({
    this.mediaSourceType = MediaSourceType.media,
  });
  final MediaSourceType mediaSourceType;
  @override
  List<Object?> get props => [mediaSourceType];
}
