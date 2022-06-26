import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import '../media_source/media.dart';
// Here for sending event callbacks.
import '../player.dart';
import 'dynamiclibrary.dart';
import 'typedefs/broadcast.dart';
import 'typedefs/chromecast.dart';
import 'typedefs/devices.dart';
import 'typedefs/equalizer.dart';
import 'typedefs/media.dart';
import 'typedefs/player.dart';
import 'typedefs/record.dart';

abstract class PlayerFFI {
  static final PlayerCreateDart create = dynamicLibrary
      .lookup<NativeFunction<PlayerCreateCXX>>('PlayerCreate')
      .asFunction();

  static final PlayerDisposeDart dispose = dynamicLibrary
      .lookup<NativeFunction<PlayerDisposeCXX>>('PlayerDispose')
      .asFunction();

  static final PlayerOpenDart open = dynamicLibrary
      .lookup<NativeFunction<PlayerOpenCXX>>('PlayerOpen')
      .asFunction();

  static final PlayerTriggerDart play = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerPlay')
      .asFunction();

  static final PlayerTriggerDart pause = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerPause')
      .asFunction();

  static final PlayerTriggerDart playOrPause = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerPlayOrPause')
      .asFunction();

  static final PlayerTriggerDart stop = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerStop')
      .asFunction();

  static final PlayerTriggerDart next = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerNext')
      .asFunction();

  static final PlayerTriggerDart previous = dynamicLibrary
      .lookup<NativeFunction<PlayerTriggerCXX>>('PlayerPrevious')
      .asFunction();

  static final PlayerJumpToIndexDart jumpToIndex = dynamicLibrary
      .lookup<NativeFunction<PlayerJumpToIndexCXX>>('PlayerJumpToIndex')
      .asFunction();

  static final PlayerSeekDart seek = dynamicLibrary
      .lookup<NativeFunction<PlayerSeekCXX>>('PlayerSeek')
      .asFunction();

  static final PlayerSetVolumeDart setVolume = dynamicLibrary
      .lookup<NativeFunction<PlayerSetVolumeCXX>>('PlayerSetVolume')
      .asFunction();

  static final PlayerSetRateDart setRate = dynamicLibrary
      .lookup<NativeFunction<PlayerSetRateCXX>>('PlayerSetRate')
      .asFunction();

  static final PlayerSetUserAgentDart setUserAgent = dynamicLibrary
      .lookup<NativeFunction<PlayerSetUserAgentCXX>>('PlayerSetUserAgent')
      .asFunction();

  static final PlayerSetEqualizerDart setEqualizer = dynamicLibrary
      .lookup<NativeFunction<PlayerSetEqualizerCXX>>('PlayerSetEqualizer')
      .asFunction();

  static final PlayerSetDeviceDart setDevice = dynamicLibrary
      .lookup<NativeFunction<PlayerSetDeviceCXX>>('PlayerSetDevice')
      .asFunction();

  static final PlayerSetPlaylistModeDart setPlaylistMode = dynamicLibrary
      .lookup<NativeFunction<PlayerSetPlaylistModeCXX>>('PlayerSetPlaylistMode')
      .asFunction();

  static final PlayerAddDart add = dynamicLibrary
      .lookup<NativeFunction<PlayerAddCXX>>('PlayerAdd')
      .asFunction();

  static final PlayerRemoveDart remove = dynamicLibrary
      .lookup<NativeFunction<PlayerRemoveCXX>>('PlayerRemove')
      .asFunction();

  static final PlayerInsertDart insert = dynamicLibrary
      .lookup<NativeFunction<PlayerInsertCXX>>('PlayerInsert')
      .asFunction();

  static final PlayerMoveDart move = dynamicLibrary
      .lookup<NativeFunction<PlayerMoveCXX>>('PlayerMove')
      .asFunction();

  static final PlayerTakeSnapshotDart takeSnapshot = dynamicLibrary
      .lookup<NativeFunction<PlayerTakeSnapshotCXX>>('PlayerTakeSnapshot')
      .asFunction();

  static final PlayerSetAudioTrackDart setAudioTrack = dynamicLibrary
      .lookup<NativeFunction<PlayerSetAudioTrackCXX>>('PlayerSetAudioTrack')
      .asFunction();

  static final PlayerGetAudioTrackCountDart getAudioTrackCount = dynamicLibrary
      .lookup<NativeFunction<PlayerGetAudioTrackCountCXX>>(
        'PlayerGetAudioTrackCount',
      )
      .asFunction();

  static final PlayerSetHWNDDart setHWND = dynamicLibrary
      .lookup<NativeFunction<PlayerSetHWNDCXX>>('PlayerSetHWND')
      .asFunction();
}

abstract class MediaFFI {
  static final MediaParseDart parse = dynamicLibrary
      .lookup<NativeFunction<MediaParseCXX>>('MediaParse')
      .asFunction();
}

abstract class BroadcastFFI {
  static final BroadcastCreateDart create = dynamicLibrary
      .lookup<NativeFunction<BroadcastCreateCXX>>('BroadcastCreate')
      .asFunction();

  static final BroadcastStartDart start = dynamicLibrary
      .lookup<NativeFunction<BroadcastStartCXX>>('BroadcastStart')
      .asFunction();

  static final BroadcastDisposeDart dispose = dynamicLibrary
      .lookup<NativeFunction<BroadcastDisposeCXX>>('BroadcastDispose')
      .asFunction();
}

abstract class ChromecastFFI {
  static final ChromecastCreateDart create = dynamicLibrary
      .lookup<NativeFunction<ChromecastCreateCXX>>('ChromecastCreate')
      .asFunction();

  static final ChromecastStartDart start = dynamicLibrary
      .lookup<NativeFunction<ChromecastStartCXX>>('ChromecastStart')
      .asFunction();

  static final ChromecastDisposeDart dispose = dynamicLibrary
      .lookup<NativeFunction<ChromecastDisposeCXX>>('ChromecastDispose')
      .asFunction();
}

abstract class RecordFFI {
  static final RecordCreateDart create = dynamicLibrary
      .lookup<NativeFunction<RecordCreateCXX>>('RecordCreate')
      .asFunction();

  static final RecordStartDart start = dynamicLibrary
      .lookup<NativeFunction<RecordStartCXX>>('RecordStart')
      .asFunction();

  static final RecordDisposeDart dispose = dynamicLibrary
      .lookup<NativeFunction<RecordDisposeCXX>>('RecordDispose')
      .asFunction();
}

abstract class DevicesFFI {
  static final DevicesAllDart all = dynamicLibrary
      .lookup<NativeFunction<DevicesAllCXX>>('DevicesAll')
      .asFunction();
}

abstract class EqualizerFFI {
  static final EqualizerCreateEmptyDart createEmpty = dynamicLibrary
      .lookup<NativeFunction<EqualizerCreateEmptyCXX>>('EqualizerCreateEmpty')
      .asFunction();

  static final EqualizerCreateModeDart createMode = dynamicLibrary
      .lookup<NativeFunction<EqualizerCreateModeCXX>>('EqualizerCreateMode')
      .asFunction();

  static final EqualizerSetBandAmpDart setBandAmp = dynamicLibrary
      .lookup<NativeFunction<EqualizerSetBandAmpCXX>>('EqualizerSetBandAmp')
      .asFunction();

  static final EqualizerSetPreAmpDart setPreAmp = dynamicLibrary
      .lookup<NativeFunction<EqualizerSetPreAmpCXX>>('EqualizerSetPreAmp')
      .asFunction();
}

bool isInitialized = false;
void Function(int id, Uint8List frame) videoFrameCallback = (_, __) {};
final ReceivePort receiver = ReceivePort()
  ..asBroadcastStream()
  ..listen((dynamic data) {
    final event = List<dynamic>.from(data as List);
    final id = event[0] as int;
    final type = event[1] as String;
    final player = players[id];
    if (player == null) return;
    switch (type) {
      case 'playbackEvent':
        {
          final playback = player.playback.copyWith(
            isPlaying: event[2] as bool,
            isSeekable: event[3] as bool,
            isCompleted: false,
          );
          player.playback = playback;
          if (!player.playbackController.isClosed) {
            player.playbackController.add(player.playback);
          }
          break;
        }
      case 'positionEvent':
        {
          player.position = player.position.copyWith(
            position: Duration(milliseconds: event[3] as int),
            duration: Duration(milliseconds: event[4] as int),
          );
          if (!player.positionController.isClosed) {
            player.positionController.add(player.position);
          }
          break;
        }
      case 'completeEvent':
        {
          player.playback = player.playback.copyWith(
            isCompleted: event[2] as bool,
          );

          if (!player.playbackController.isClosed) {
            player.playbackController.add(player.playback);
          }
          break;
        }
      case 'volumeEvent':
        {
          player.general = player.general.copyWith(
            volume: event[2] as double,
          );
          if (!player.generalController.isClosed) {
            player.generalController.add(player.general);
          }
          break;
        }
      case 'rateEvent':
        {
          player.general = player.general.copyWith(
            rate: event[2] as double,
          );

          if (!player.generalController.isClosed) {
            player.generalController.add(player.general);
          }
          break;
        }
      case 'openEvent':
        {
          player.current = player.current.copyWith(
            index: event[2] as int,
            isPlaylist: event[3] as bool,
          );
          final list1 = List<String>.from(event[4] as List);
          final list2 = List<String>.from(event[5] as List);
          assert(
            list1.length == list2.length,
            'list1 and list2 must be the same length',
          );
          final length = list1.length;
          final medias = <Media>[];
          for (var index = 0; index < length; index++) {
            switch (list1[index]) {
              case 'MediaType.file':
                {
                  medias.add(Media.file(File(list2[index])));
                  break;
                }
              case 'MediaType.network':
                {
                  medias.add(Media.network(Uri.parse(list2[index])));
                  break;
                }
              case 'MediaType.direct_show':
                {
                  medias.add(Media.directShow(rawUrl: list2[index]));
                  break;
                }
            }
          }
          player.current = player.current.copyWith(
            media: medias.elementAt(player.current.index!),
            medias: medias,
          );
          if (!player.currentController.isClosed) {
            player.currentController.add(player.current);
          }
          break;
        }
      case 'videoDimensionsEvent':
        {
          player.videoDimensions =
              VideoDimensions(event[2] as int, event[3] as int);

          if (!player.videoDimensionsController.isClosed) {
            player.videoDimensionsController.add(player.videoDimensions);
          }
          break;
        }
      case 'videoFrameEvent':
        {
          videoFrameCallback(id, event[2] as Uint8List);
          break;
        }
      case 'bufferingEvent':
        {
          player.bufferingProgress = event[2] as double;
          if (!player.bufferingProgressController.isClosed) {
            player.bufferingProgressController.add(player.bufferingProgress);
          }
          break;
        }
      default:
        {
          player.error = '${event[2]}';
          if (!player.errorController.isClosed) {
            player.errorController.add(player.error);
          }
          break;
        }
    }
  });
