#ifndef FLUTTER_PLUGIN_WINHOOKER_MOUSE_PLUGIN_H_
#define FLUTTER_PLUGIN_WINHOOKER_MOUSE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace winhooker_mouse {

class WinhookerMousePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WinhookerMousePlugin();

  virtual ~WinhookerMousePlugin();

  // Disallow copy and assign.
  WinhookerMousePlugin(const WinhookerMousePlugin&) = delete;
  WinhookerMousePlugin& operator=(const WinhookerMousePlugin&) = delete;
 static void showText(LPCTSTR text);
 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
          flutter::PluginRegistrarWindows *registrar_;
          static const char kOnLogCallbackMethod[];
          static const char kGetVirtualKeyMapMethod[];
            #ifdef KEYEVENT_DEBUG
              UINT _codePage;
            #endif
};

}  // namespace winhooker_mouse

#endif  // FLUTTER_PLUGIN_WINHOOKER_MOUSE_PLUGIN_H_
