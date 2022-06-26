// ignore_for_file: comment_references

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'internal/ffi.dart';

/// Represents a playback [Device] for the [Player].
class Device {
  const Device(this.id, this.name);

  /// ID corresponding to the [Device].
  final String id;

  /// Name of the [Device].
  final String name;
}

/// [Devices.all] getter is used to get [List] of all available [Device] for playback in the [Player].
class Devices {
  /// Gets [List] of all available playback [Device].
  static List<Device> get all {
    final devices = <Device>[];
    final _devices = DevicesFFI.all(devices);
    for (var i = 0; i < _devices.ref.size; i++) {
      final _device = _devices.ref.devices.elementAt(i);
      devices.add(
        Device(
          _device.ref.id.toDartString(),
          _device.ref.name.toDartString(),
        ),
      );
    }
    return devices;
  }
}
