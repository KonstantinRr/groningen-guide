'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "icons/Icon-512.png": "65ffb79f3d384ed474d1d49ed4fd570c",
"icons/Icon-192.png": "7df343626c76a95610d05808542ae1a2",
"icons/icon-angel-statue.png": "00e7fd5f6cb029d4638528917f998b87",
"manifest.json": "2d8733ee32a8963fac0e79866e5a0c4b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b14fcf3ee94e3ace300b192e9e7c8c5d",
"assets/NOTICES": "97ee6926e6a428963c359b994f58d318",
"assets/assets/knowledge_base.json": "57a75c4dd769b205eb1ac23c472ac4d8",
"assets/assets/images/KlipperZwaddeboatHotel.jpg": "6173e6dc64194c64d8ff636b81ac12db",
"assets/assets/images/pure.jpg": "0fb14306f8a92738570b2786a01eb89c",
"assets/assets/images/vapiano.jpg": "15729f686ae3eed746fd5e39633a9bb5",
"assets/assets/images/voila.jpg": "73048166fcb42c28cf8abd8058f8ebaf",
"assets/assets/images/chofah.jpg": "2e4e0bfce27eafa0237c38b6e89f2b45",
"assets/assets/images/imono.jpg": "75f326dcd90ce0374a14e4959f3d229e",
"assets/assets/images/houdtVanEten.jpg": "59382a8f321c8ce89bd38f1225048396",
"assets/assets/images/smoothBrothers.jpg": "37b24fa326f6df594e2f7bdbe6a3f39d",
"assets/assets/images/nassau.jpg": "f5356ee3ff0ab1424b9042086ebff5b4",
"assets/assets/images/magoya.jpg": "ee0f02c4b317eaec3c6c4586053c448b",
"assets/assets/images/davinci.jpg": "010cf8a40eef09bfdffa8107f77722f9",
"assets/assets/images/tiantianle.jpg": "5092e146c5fe85ae7c14b34fd5b0bdca",
"assets/assets/images/cityHotel.jpg": "c8713dfdcf4bc11152ffb2e23ebd168b",
"assets/assets/images/mrmofongo.png": "551c95853319677abff9336ccf2aef23",
"assets/assets/images/theManor.jpg": "6171c2d53fe9d0c120a9514da3e51388",
"assets/assets/images/konbu.jpg": "46f3027bd2c2347e4d03c47c277aefd4",
"assets/assets/images/chocoCompany.jpg": "58e00956f6f8cbaf44970b3da59ad926",
"assets/assets/images/corpsGarde.jpg": "7cb56027e8f8043e0ea5b985c4b208a7",
"assets/assets/images/mercure.jpg": "1fa683d9a4eb30dd48cfcbfd453d25e9",
"assets/assets/images/gustatio.jpg": "35425a416dcefd13c4de116786670e8e",
"assets/assets/images/mrsmith.jpg": "154fb706fa40a1417b73865e33f04f10",
"assets/assets/images/debeteretijden.jpg": "8b625f8b5966fc036eda9acb08cc74aa",
"assets/assets/images/apolloHotel.jpg": "5c2530c2040c9dbd8857e2354c451780",
"assets/assets/images/deKleineHeerlijkheid.jpg": "7eba3b4d6a69707b4af6300fcc83771f",
"assets/assets/images/tucano.jpg": "e50888c32ae9fe33e57fec33dfdabdfd",
"assets/assets/images/deDoelen.jpg": "c11f09132f4a42db72762650356937d7",
"assets/assets/images/logo.png": "eb87682d0f8cc1ffe9b7f5df38957476",
"assets/assets/images/turtle128x.png": "4f2d9d1a9f3d433ae773beffe78b4178",
"assets/assets/images/turtle.png": "65ffb79f3d384ed474d1d49ed4fd570c",
"assets/assets/images/de3gezusters.jpg": "a7fb49da2b0eeab34334286a4dfc6316",
"assets/assets/images/steeInStad.jpg": "1944d70bbc9aeb59f2b171521405bb16",
"assets/assets/images/deUurwerker.jpg": "6e9f25062f2e4bca060e45289643caee",
"assets/assets/images/bronco.jpg": "b360ab86e4c1486909e7e4413774ff4e",
"assets/assets/images/nhDeVille.jpg": "5be9b3975b678a4f910a1fe78324b832",
"assets/assets/images/cappuvino.jpg": "e166f9676976835faee0179311b35a38",
"assets/assets/images/strabucksUB.jpg": "ae5d8f7d7cd564c45c5acecc503c76ab",
"assets/assets/images/thaijasmine.jpg": "47d4790fdf750cd8ef4adc3f38635cce",
"assets/assets/images/coffeeCompany.jpg": "332c4e70a7173b9a764f47d01aaab796",
"assets/assets/images/Asgard.jpg": "602342820f838e5d2aa4cb5649d380eb",
"assets/assets/images/groMap.jpg": "2d3b1fd82c37c341f4b7658c10789017",
"assets/assets/images/prinsenhofHotel.jpg": "b6c1a01f3b2ae7648752e87cb7a6d611",
"assets/assets/images/missBlanche.jpg": "567661b59632dce31825159adbdfe5ad",
"assets/assets/images/boccaccio.jpg": "2aeabbcddce4e073a4a27d76b76155d9",
"assets/assets/images/studentHotel.jpg": "5a4a5de6dbeb29f67df76ef89b487b0e",
"assets/assets/images/pastaFabriek.jpg": "874755e922c0ebe8d0b8bf742f5d44fe",
"assets/assets/images/vivelavie.jpg": "9cc6a021b7256832b04f10c0f452979b",
"assets/assets/images/changThaiBistro.jpg": "a6b4f753640bede66162af93cc7f97d8",
"assets/assets/images/doppioEspresso.jpg": "23d785ea8cb9f3fdd229675ce0ee36ca",
"assets/assets/images/chaplinsPub.jpg": "1912b2d8a17421f14a7c2dcde5bfb996",
"assets/assets/images/martini.jpg": "085caeb4ec8f1e9d5747ce119805c69c",
"assets/assets/images/groen.jpg": "49aa7ea18ac891e79b6e8445c8db0c8d",
"assets/assets/images/deOlijfboom.jpg": "2dfbe206fdd55806dcca0df60ee060e8",
"assets/assets/images/dePijp.jpg": "da4c733a47f84405ee91004619c3dd07",
"assets/assets/images/asiaToday.jpg": "eeed7d05de8bded757fa10dfca35222a",
"assets/assets/images/pannekoekschip.jpg": "0770060cdc0bd62a69a2e2b93a241d5b",
"assets/assets/images/hanasato.jpg": "8f44a64dede2d78f4d8c835a7f60da1c",
"assets/assets/images/blackBloom.jpg": "d801d94a36bb24ad50aef182ac8b689c",
"assets/assets/images/turtle2.png": "17e0e43a2f4b6fec66cb4ee59ff3d39c",
"assets/AssetManifest.json": "e127c30091552bb80adedfe000ba891f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"index.html": "144d908464aec1e52ef4b9ae18a4ba63",
"/": "144d908464aec1e52ef4b9ae18a4ba63",
"version.json": "a6fc3fd6e84615acff6fd79e0b9601a7",
"main.dart.js": "6c51d7f8a940c04f39f24e4785cc44a1",
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
