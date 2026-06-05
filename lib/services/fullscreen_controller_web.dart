import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<bool> enterImmersiveMode() async {
  var didRequestFullscreen = false;

  try {
    final element = web.document.documentElement;
    if (element != null && web.document.fullscreenElement == null) {
      await element.requestFullscreen().toDart;
      didRequestFullscreen = true;
    }
  } catch (_) {
    // Some mobile browsers only allow fullscreen from specific user gestures.
  }

  try {
    await web.window.screen.orientation.lock('landscape').toDart;
  } catch (_) {
    // Orientation lock is best-effort and often requires fullscreen/PWA mode.
  }

  try {
    web.window.scrollTo(0.toJS, 1);
  } catch (_) {
    // Best-effort address bar nudge for older mobile browsers.
  }

  return didRequestFullscreen || web.document.fullscreenElement != null;
}

Future<bool> toggleImmersiveMode() async {
  if (web.document.fullscreenElement != null) {
    try {
      await web.document.exitFullscreen().toDart;
      try {
        web.window.screen.orientation.unlock();
      } catch (_) {
        // Orientation unlock is best-effort.
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  return enterImmersiveMode();
}
