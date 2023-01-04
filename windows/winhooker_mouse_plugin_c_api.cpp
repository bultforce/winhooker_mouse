#include "include/winhooker_mouse/winhooker_mouse_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "winhooker_mouse_plugin.h"

void WinhookerMousePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  winhooker_mouse::WinhookerMousePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
