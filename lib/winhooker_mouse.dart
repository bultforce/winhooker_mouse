
import 'winhooker_mouse_platform_interface.dart';

class WinhookerMouse {
  Future<String?> getPlatformVersion() {
    return WinhookerMousePlatform.instance.getPlatformVersion();
  }
  Stream<dynamic> streamMouseHook() {
    return WinhookerMousePlatform.instance.streamMouseEventFromNative();
  }
}
