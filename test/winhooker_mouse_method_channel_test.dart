import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winhooker_mouse/winhooker_mouse_method_channel.dart';

void main() {
  MethodChannelWinhookerMouse platform = MethodChannelWinhookerMouse();
  const MethodChannel channel = MethodChannel('winhooker_mouse');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
