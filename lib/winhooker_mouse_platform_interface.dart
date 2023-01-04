import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'winhooker_mouse_method_channel.dart';

abstract class WinhookerMousePlatform extends PlatformInterface {
  /// Constructs a WinhookerMousePlatform.
  WinhookerMousePlatform() : super(token: _token);

  static final Object _token = Object();

  static WinhookerMousePlatform _instance = MethodChannelWinhookerMouse();

  /// The default instance of [WinhookerMousePlatform] to use.
  ///
  /// Defaults to [MethodChannelWinhookerMouse].
  static WinhookerMousePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WinhookerMousePlatform] when
  /// they register themselves.
  static set instance(WinhookerMousePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  Stream<dynamic> streamMouseEventFromNative() {
    throw UnimplementedError('streamMouseEventFromNative() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
