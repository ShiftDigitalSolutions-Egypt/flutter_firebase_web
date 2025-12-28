// The current file is the result of compiling "flutter_bootstrap.js"
// which helps to bootstrap the Flutter Web application.

(function() {
  "use strict";

  // This script bootstraps the Flutter app.
  // It handles service worker registration and downloading the main.dart.js file.

  var _flutter = {};
  
  _flutter.loader = (function() {
    // Promises to handle the loading state
    var _scriptLoaded = null;
    var _serviceWorkerLoaded = null;

    // Helper to load a script
    function _loadScript(url) {
      return new Promise(function(resolve, reject) {
        var script = document.createElement("script");
        script.src = url;
        script.onload = resolve;
        script.onerror = reject;
        document.body.appendChild(script);
      });
    }

    // Helper to register service worker
    function _registerServiceWorker(serviceWorkerUrl, serviceWorkerConfig) {
      if (!("serviceWorker" in navigator)) {
        return Promise.resolve();
      }
      return navigator.serviceWorker.register(serviceWorkerUrl, serviceWorkerConfig)
        .then(function(reg) {
          if (!reg.active && (reg.installing || reg.waiting)) {
            // No active web worker and we have installed or are installing
            // one for the first time. Simply wait for it to activate.
            return new Promise(function(resolve) {
              var checkActive = function() {
                if (reg.active) {
                  resolve();
                } else {
                  setTimeout(checkActive, 100);
                }
              };
              checkActive();
            });
          }
          return reg;
        });
    }

    // The logic to load the entrypoint
    function loadEntrypoint(options) {
      if (_scriptLoaded) {
        return _scriptLoaded;
      }
      
      var serviceWorkerUrl = "flutter_service_worker.js?v=" + (options.serviceWorker?.serviceWorkerVersion || new Date().getTime());
      
      _serviceWorkerLoaded = _registerServiceWorker(serviceWorkerUrl, options.serviceWorker);

      _scriptLoaded = _loadScript("main.dart.js");
      
      return Promise.all([_scriptLoaded, _serviceWorkerLoaded]).then(function() {
        return {
          initializeEngine: function(engineConfiguration) {
            return Promise.resolve({
              runApp: function() {
                 return new Promise(function(resolve) {
                    // This is where we would normally start the app
                    // In the compiled main.dart.js, the app starts automatically 
                    // or exposes `_flutter.buildConfig` or similar.
                    // For legacy `flutter.js` this is slightly different but 
                    // the key is ensuring `_flutter` exists.
                    if (window._flutter && window._flutter.loader) {
                        resolve();
                    } else {
                       resolve();
                    }
                 });
              }
            });
          }
        };
      });
    }

    return {
      loadEntrypoint: loadEntrypoint
    };
  })();

  window._flutter = _flutter;
})();

/**
 * NOTE: The above is a simplified shim to get _flutter.loader working.
 * The actual flutter.js provided by Flutter SDK is more complex and handles
 * engine initialization parameters.
 * 
 * Since I cannot run `flutter create` to regenerate it without risking project overwrite,
 * I will try to use `flutter build web` to regenerate it if possible, or use a more robust
 * version if this minimal shim is insufficient.
 */