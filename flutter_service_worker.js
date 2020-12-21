'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "icons/Icon-512.png": "65ffb79f3d384ed474d1d49ed4fd570c",
"icons/Icon-192.png": "7df343626c76a95610d05808542ae1a2",
"manifest.json": "c74d4dfd05b36e961108285b7ecc821c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b14fcf3ee94e3ace300b192e9e7c8c5d",
"assets/NOTICES": "97ee6926e6a428963c359b994f58d318",
"assets/assets/knowledge_base.json": "8b81184369807db8b268295a5e85e0a0",
"assets/assets/images/KlipperZwaddeboatHotel.jpg": "6173e6dc64194c64d8ff636b81ac12db",
"assets/assets/images/smoothBrothers.jpg": "37b24fa326f6df594e2f7bdbe6a3f39d",
"assets/assets/images/cityHotel.jpg": "c8713dfdcf4bc11152ffb2e23ebd168b",
"assets/assets/images/theManor.jpg": "6171c2d53fe9d0c120a9514da3e51388",
"assets/assets/images/chocoCompany.jpg": "58e00956f6f8cbaf44970b3da59ad926",
"assets/assets/images/corpsGarde.jpg": "7cb56027e8f8043e0ea5b985c4b208a7",
"assets/assets/images/mercure.jpg": "1fa683d9a4eb30dd48cfcbfd453d25e9",
"assets/assets/images/logo.png": "eb87682d0f8cc1ffe9b7f5df38957476",
"assets/assets/images/turtle128x.png": "4f2d9d1a9f3d433ae773beffe78b4178",
"assets/assets/images/turtle.png": "65ffb79f3d384ed474d1d49ed4fd570c",
"assets/assets/images/steeInStad.jpg": "1944d70bbc9aeb59f2b171521405bb16",
"assets/assets/images/nhDeVille.jpg": "5be9b3975b678a4f910a1fe78324b832",
"assets/assets/images/Asgard.jpg": "602342820f838e5d2aa4cb5649d380eb",
"assets/assets/images/groMap.jpg": "2d3b1fd82c37c341f4b7658c10789017",
"assets/assets/images/prinsenhofHotel.jpg": "b6c1a01f3b2ae7648752e87cb7a6d611",
"assets/assets/images/missBlanche.jpg": "567661b59632dce31825159adbdfe5ad",
"assets/assets/images/studentHotel.jpg": "5a4a5de6dbeb29f67df76ef89b487b0e",
"assets/assets/images/martini.jpg": "085caeb4ec8f1e9d5747ce119805c69c",
"assets/assets/images/blackBloom.jpg": "d801d94a36bb24ad50aef182ac8b689c",
"assets/AssetManifest.json": "6dc8996e1d4211f77d599d416efaf5b0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"index.html": "82638bba1fefe87af250b67d88833cc5",
"/": "82638bba1fefe87af250b67d88833cc5",
"version.json": "a6fc3fd6e84615acff6fd79e0b9601a7",
"main.dart.js": "af364ff617dbc8e6ac3cc78f9b5c130f",
"favicon.png": "72774a7b5a4a54dc7d8fe364fc7b3d8f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
