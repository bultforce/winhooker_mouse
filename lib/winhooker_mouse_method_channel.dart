import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'winhooker_mouse_platform_interface.dart';

/// An implementation of [WinhookerMousePlatform] that uses method channels.
typedef keyboardEventListener = void Function(KeyEvent keyEvent);
typedef CancelListening = void Function();
KeyEventMsg toKeyEventMsg(int v) {
  KeyEventMsg keyMsg;
  switch (v) {
    case 0:
      keyMsg = KeyEventMsg.WM_KEYDOWN;
      break;
    case 1:
      keyMsg = KeyEventMsg.WM_KEYUP;
      break;
    case 2:
      keyMsg = KeyEventMsg.WM_SYSKEYDOWN;
      break;
    case 3:
      keyMsg = KeyEventMsg.WM_SYSKEYDOWN;
      break;
    default:
      keyMsg = KeyEventMsg.WM_UNKNOW;
      break;
  }
  return keyMsg;
}
class MethodChannelWinhookerMouse extends WinhookerMousePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('winhooker_mouse');
  var mouseEventChannel = const EventChannel('win_tracker_mouse');
  StreamController onMouseEvent =  StreamController();
  KeyBoardState mouseState = KeyBoardState();
  static Map<String, int>? virtualKeyString2CodeMap;
  static Map<int, List<String>>? virtualKeyCode2StringMap;
  CancelListening? _cancelKeyboardListening;
  CancelListening? _cancelMouseListening;
  static bool? isLeter(int vk) {
    if (MethodChannelWinhookerMouse.virtualKeyCode2StringMap != null) {
      var A = MethodChannelWinhookerMouse.virtualKeyString2CodeMap!['A'];
      var Z = MethodChannelWinhookerMouse.virtualKeyString2CodeMap!['Z'];
      if ((vk >= A!) && (vk <= Z!)) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  cancelKeyboardListening() async {
    if (_cancelKeyboardListening != null) {
      _cancelKeyboardListening!();
      _cancelKeyboardListening = null;
    } else {
      debugPrint("win_tracker/screen_capture/event No Need");
    }
  }
  static bool? isNumber(int vk) {
    if (MethodChannelWinhookerMouse.virtualKeyCode2StringMap != null) {
      var key_0 = MethodChannelWinhookerMouse.virtualKeyString2CodeMap!['0'];
      var key_9 = MethodChannelWinhookerMouse.virtualKeyString2CodeMap!['9'];
      if ((vk >= key_0!) && (vk <= key_9!)) {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }
  @override
  Stream<dynamic> streamMouseEventFromNative() {
    if(Platform.isWindows){
      startMouseWindowListening();
      onMouseEvent.sink.add("event");
      return onMouseEvent.stream;
    }
    return onMouseEvent.stream;

  }
  Future<void> startMouseWindowListening() async{
    var subscription =
    mouseEventChannel.receiveBroadcastStream("mouse_event").listen(//listener
            (dynamic msg) {
          var list = List<int>.from(msg);
          var keyEvent = KeyEvent(list);
          if (keyEvent.isKeyDown) {
            if (!mouseState.state.contains(keyEvent.vkCode)) {
              mouseState.state.add(keyEvent.vkCode);
            }
          } else {
            if (mouseState.state.contains(keyEvent.vkCode)) {
              mouseState.state.remove(keyEvent.vkCode);
            }
          }
          onMouseEvent.sink.add(keyEvent);
        }, cancelOnError: true);
    debugPrint("mouse_event/event startListening");
    _cancelMouseListening = () {
      subscription.cancel();
      debugPrint("mouse_event/event canceled");
    };
  }
}
class KeyEvent {
  late KeyEventMsg keyMsg;
  late int vkCode;
  late int scanCode;
  late int flags;
  late int time;
  late int dwExtraInfo;

  KeyEvent(List<int> list) {
    keyMsg = toKeyEventMsg(list[0]);
    vkCode = list[1];
    scanCode = list[2];
    flags = list[3];
    time = list[4];
    dwExtraInfo = list[5];
  }

  bool get isKeyUP =>
      (keyMsg == KeyEventMsg.WM_KEYUP) || (keyMsg == KeyEventMsg.WM_SYSKEYUP);
  bool get isKeyDown => !isKeyUP;
  bool get isSysKey =>
      (keyMsg == KeyEventMsg.WM_SYSKEYUP) ||
          (keyMsg == KeyEventMsg.WM_SYSKEYDOWN);

  String? get vkName => MethodChannelWinhookerMouse.virtualKeyCode2StringMap?[vkCode]?[0];

  bool? get isLeter => MethodChannelWinhookerMouse.isLeter(vkCode);
  bool? get isNumber => MethodChannelWinhookerMouse.isNumber(vkCode);

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write('${DateTime.now().millisecondsSinceEpoch}-$vkCode');
    return sb.toString();
  }
}
class KeyBoardState {
  Set<int> state = <int>{};
  KeyBoardState();
  @override
  String toString() {
    if (MethodChannelWinhookerMouse.virtualKeyCode2StringMap != null) {
      var sb = StringBuffer();
      bool isFirst = true;
      sb.write('[');
      for (var key in state) {
        if (isFirst) {
          isFirst = false;
        } else {
          sb.write(',');
        }
        var str = MethodChannelWinhookerMouse.virtualKeyCode2StringMap![key]?[0];
        sb.write(str ?? key.toString());
      }
      sb.write(']');
      return sb.toString();
    } else {
      return state.toString();
    }
  }
}
typedef CancelScreenListening = void Function();
enum KeyEventMsg { WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP, WM_UNKNOW }