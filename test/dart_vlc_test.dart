import 'package:flutter_test/flutter_test.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:dart_vlc/dart_vlc_platform_interface.dart';
import 'package:dart_vlc/dart_vlc_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDartVlcPlatform 
    with MockPlatformInterfaceMixin
    implements DartVlcPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DartVlcPlatform initialPlatform = DartVlcPlatform.instance;

  test('$MethodChannelDartVlc is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDartVlc>());
  });

  test('getPlatformVersion', () async {
    DartVlc dartVlcPlugin = DartVlc();
    MockDartVlcPlatform fakePlatform = MockDartVlcPlatform();
    DartVlcPlatform.instance = fakePlatform;
  
    expect(await dartVlcPlugin.getPlatformVersion(), '42');
  });
}
