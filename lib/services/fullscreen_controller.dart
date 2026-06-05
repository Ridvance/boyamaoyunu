import 'fullscreen_controller_stub.dart'
    if (dart.library.html) 'fullscreen_controller_web.dart'
    as impl;

class FullscreenController {
  static Future<bool> enterImmersiveMode() {
    return impl.enterImmersiveMode();
  }
}
