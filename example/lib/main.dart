import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  await DartVLC.initialize(useFlutterNativeView: true);
  runApp(const DartVLCExample());
}

class DartVLCExample extends StatefulWidget {
  const DartVLCExample({Key? key}) : super(key: key);

  @override
  DartVLCExampleState createState() => DartVLCExampleState();
}

class DartVLCExampleState extends State<DartVLCExample> {
  Player player = Player(
    id: 0,
    videoDimensions: const VideoDimensions(640, 360),
    registerTexture: !Platform.isWindows,
  );
  MediaType mediaType = MediaType.file;
  CurrentState current = const CurrentState();
  PositionState position = const PositionState();
  PlaybackState playback = const PlaybackState();
  GeneralState general = const GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];
  List<Device> devices = <Device>[];
  TextEditingController controller = TextEditingController();
  TextEditingController metasController = TextEditingController();
  double bufferingProgress = 0;
  Media? metasMedia;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      player.currentStream.listen((current) {
        setState(() => this.current = current);
      });
      player.positionStream.listen((position) {
        setState(() => this.position = position);
      });
      player.playbackStream.listen((playback) {
        setState(() => this.playback = playback);
      });
      player.generalStream.listen((general) {
        setState(() => this.general = general);
      });
      player.videoDimensionsStream.listen((videoDimensions) {
        setState(() => this.videoDimensions = videoDimensions);
      });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        log('libvlc error.');
      });
      devices = Devices.all;
      final equalizer = Equalizer.createMode(EqualizerMode.live)
        ..setPreAmp(10)
        ..setBandAmp(31.25, 10);
      player.setEqualizer(equalizer);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet;
    bool isPhone;
    final devicePixelRatio = ui.window.devicePixelRatio;
    final width = ui.window.physicalSize.width;
    final height = ui.window.physicalSize.height;
    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade700,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: ui.Color.fromARGB(255, 54, 214, 115),
          secondary: ui.Color.fromARGB(255, 157, 222, 182),
        ),
        useMaterial3: true,
      ),
      scrollBehavior: [
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.windows
      ].contains(defaultTargetPlatform)
          ? const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            )
          : const MaterialScrollBehavior(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('dart_vlc'),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Platform.isWindows)
                  NativeVideo(
                    player: player,
                    width: isPhone ? 320 : 640,
                    height: isPhone ? 180 : 360,
                    volumeThumbColor: Colors.blue,
                    volumeActiveColor: Colors.blue,
                    showControls: !isPhone,
                  )
                else
                  Video(
                    player: player,
                    width: isPhone ? 320 : 640,
                    height: isPhone ? 180 : 360,
                    volumeThumbColor: Colors.blue,
                    volumeActiveColor: Colors.blue,
                    showControls: !isPhone,
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPhone) _controls(context, isPhone),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  const Text('Playlist creation.'),
                                  const Divider(
                                    height: 8,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: controller,
                                          cursorWidth: 1,
                                          autofocus: true,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          decoration:
                                              const InputDecoration.collapsed(
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            hintText: 'Enter Media path.',
                                          ),
                                        ),
                                      ),
                                      DropdownButton<MediaType>(
                                        value: mediaType,
                                        elevation: 0,
                                        underline: const SizedBox.shrink(),
                                        onChanged: (mediaType) => setState(
                                          () => this.mediaType = mediaType!,
                                        ),
                                        items: [
                                          DropdownMenuItem<MediaType>(
                                            value: MediaType.file,
                                            child: Text(
                                              MediaType.file.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<MediaType>(
                                            value: MediaType.network,
                                            child: Text(
                                              MediaType.network.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem<MediaType>(
                                            value: MediaType.asset,
                                            child: Text(
                                              MediaType.asset.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (mediaType == MediaType.file) {
                                              medias.add(
                                                Media.file(
                                                  File(
                                                    controller.text.replaceAll(
                                                      '"',
                                                      '',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (mediaType ==
                                                MediaType.network) {
                                              medias.add(
                                                Media.network(
                                                  controller.text,
                                                ),
                                              );
                                            }
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Add to Playlist',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 12,
                                  ),
                                  const Divider(
                                    height: 8,
                                    color: Colors.transparent,
                                  ),
                                  const Text('Playlist'),
                                ] +
                                medias
                                    .map(
                                      (media) => ListTile(
                                        title: Text(
                                          media.resource,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        subtitle: Text(
                                          media.mediaType.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList() +
                                <Widget>[
                                  const Divider(
                                    height: 8,
                                    color: Colors.transparent,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => setState(
                                          () {
                                            player.open(
                                              Playlist(
                                                medias: medias,
                                              ),
                                            );
                                          },
                                        ),
                                        child: const Text(
                                          'Open into Player',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () => medias.clear(),
                                          );
                                        },
                                        child: const Text(
                                          'Clear the list',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Playback event listeners.'),
                              const Divider(
                                height: 12,
                                color: Colors.transparent,
                              ),
                              const Divider(
                                height: 12,
                              ),
                              const Text('Playback position.'),
                              const Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              Slider(
                                max:
                                    position.duration.inMilliseconds.toDouble(),
                                value:
                                    position.position.inMilliseconds.toDouble(),
                                onChanged: (double position) => player.seek(
                                  Duration(
                                    milliseconds: position.toInt(),
                                  ),
                                ),
                              ),
                              const Text('Event streams.'),
                              const Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              Table(
                                children: [
                                  TableRow(
                                    children: [
                                      const Text('player.general.volume'),
                                      Text('${general.volume}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.general.rate'),
                                      Text('${general.rate}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.position.position'),
                                      Text('${position.position}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.position.duration'),
                                      Text('${position.duration}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.playback.isCompleted'),
                                      Text('${playback.isCompleted}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.playback.isPlaying'),
                                      Text('${playback.isPlaying}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.playback.isSeekable'),
                                      Text('${playback.isSeekable}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.current.index'),
                                      Text('${current.index}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.current.media'),
                                      Text('${current.media}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.current.medias'),
                                      Text('${current.medias}')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.videoDimensions'),
                                      Text('$videoDimensions')
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      const Text('player.bufferingProgress'),
                                      Text('$bufferingProgress')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                                  Text('Playback devices.'),
                                  Divider(
                                    height: 12,
                                    color: Colors.transparent,
                                  ),
                                  Divider(
                                    height: 12,
                                  ),
                                ] +
                                devices
                                    .map(
                                      (device) => ListTile(
                                        title: Text(
                                          device.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        subtitle: Text(
                                          device.id,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        onTap: () => player.setDevice(device),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Metas parsing.'),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: metasController,
                                      cursorWidth: 1,
                                      autofocus: true,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                        ),
                                        hintText: 'Enter Media path.',
                                      ),
                                    ),
                                  ),
                                  DropdownButton<MediaType>(
                                    value: mediaType,
                                    onChanged: (mediaType) => setState(
                                      () => this.mediaType = mediaType!,
                                    ),
                                    underline: const SizedBox.shrink(),
                                    items: [
                                      DropdownMenuItem<MediaType>(
                                        value: MediaType.file,
                                        child: Text(
                                          MediaType.file.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<MediaType>(
                                        value: MediaType.network,
                                        child: Text(
                                          MediaType.network.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<MediaType>(
                                        value: MediaType.asset,
                                        child: Text(
                                          MediaType.asset.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (mediaType == MediaType.file) {
                                          metasMedia = Media.file(
                                            File(metasController.text),
                                            parse: true,
                                          );
                                        } else if (mediaType ==
                                            MediaType.network) {
                                          metasMedia = Media.network(
                                            metasController.text,
                                            parse: true,
                                          );
                                        }
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Parse',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 12,
                              ),
                              const Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              Text(
                                const JsonEncoder.withIndent('    ')
                                    .convert(metasMedia?.metas),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isPhone) _playlist(context),
                    ],
                  ),
                ),
                if (isTablet)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _controls(context, isPhone),
                        _playlist(context),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _controls(BuildContext context, bool isPhone) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Playback controls.'),
            const Divider(
              height: 8,
              color: Colors.transparent,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.play(),
                  child: const Text(
                    'play',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => player.pause(),
                  child: const Text(
                    'pause',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => player.playOrPause(),
                  child: const Text(
                    'playOrPause',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => player.stop(),
                  child: const Text(
                    'stop',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => player.next(),
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => player.previous(),
                  child: const Text(
                    'previous',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 12,
              color: Colors.transparent,
            ),
            const Divider(
              height: 12,
            ),
            const Text('Volume control.'),
            const Divider(
              height: 8,
              color: Colors.transparent,
            ),
            Slider(
              value: player.general.volume,
              onChanged: (volume) {
                player.setVolume(volume);
                setState(() {});
              },
            ),
            const Text('Playback rate control.'),
            const Divider(
              height: 8,
              color: Colors.transparent,
            ),
            Slider(
              min: 0.5,
              max: 1.5,
              value: player.general.rate,
              onChanged: (rate) {
                player.setRate(rate);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _playlist(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Playlist manipulation.'),
                Divider(
                  height: 12,
                  color: Colors.transparent,
                ),
                Divider(
                  height: 12,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 456,
            child: ReorderableListView(
              shrinkWrap: true,
              onReorder: (int initialIndex, int finalIndex) async {
                /// 🙏🙏🙏
                /// In the name of God,
                /// With all due respect,
                /// I ask all Flutter engineers to please fix this issue.
                /// Peace.
                /// 🙏🙏🙏
                ///
                /// Issue:
                /// https://github.com/flutter/flutter/issues/24786
                /// Prevention:
                /// https://stackoverflow.com/a/54164333/12825435
                ///
                if (finalIndex > current.medias.length) {
                  finalIndex = current.medias.length;
                }
                if (initialIndex < finalIndex) finalIndex--;

                player.move(initialIndex, finalIndex);
                setState(() {});
              },
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: List.generate(
                current.medias.length,
                (int index) => ListTile(
                  key: Key(index.toString()),
                  leading: Text(
                    index.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  title: Text(
                    current.medias[index].resource,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    current.medias[index].mediaType.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
