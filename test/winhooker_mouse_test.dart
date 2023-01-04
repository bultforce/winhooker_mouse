import 'package:flutter_test/flutter_test.dart';
import 'package:winhooker_mouse/winhooker_mouse.dart';
import 'package:winhooker_mouse/winhooker_mouse_platform_interface.dart';
import 'package:winhooker_mouse/winhooker_mouse_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWinhookerMousePlatform
    with MockPlatformInterfaceMixin
    implements WinhookerMousePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WinhookerMousePlatform initialPlatform = WinhookerMousePlatform.instance;

  test('$MethodChannelWinhookerMouse is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWinhookerMouse>());
  });

  test('getPlatformVersion', () async {
    WinhookerMouse winhookerMousePlugin = WinhookerMouse();
    MockWinhookerMousePlatform fakePlatform = MockWinhookerMousePlatform();
    WinhookerMousePlatform.instance = fakePlatform;

    expect(await winhookerMousePlugin.getPlatformVersion(), '42');
  });
}
