'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "a91132d63cf94aac33b8bb50fba6a77d",
"version.json": "109b72a8fbf34e0b2d908f41cd471b48",
"index.html": "2b686b23c330e027e3c66b62a184a050",
"/": "2b686b23c330e027e3c66b62a184a050",
"main.dart.js": "4233c1ce03e02524c57f2d04e79122da",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "965a3173f74125c504b0190718c08d4b",
".git/ORIG_HEAD": "23da28a69d14c2c233821f2b8f1f133e",
".git/config": "e90e06acefc16e8834338302454a256b",
".git/objects/59/8004148208a60f8605d69158758475d60ab9ea": "1b7039ed5ff375ea2a6c5391af45cd85",
".git/objects/59/a024af0601c6809e267eff510d5c2403db58c2": "0c9afa745fd4563085917d11709f489a",
".git/objects/66/ef8ca0c6d352e364d2bc9134b77dd0a620e7aa": "6c06917afbe2c665342d2ef2622bfa1b",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/57/d3ea3ed43774328c880811b59b95ee39b96c50": "bd84cc8b777085aea0071ed883b66633",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/9e/26dfeeb6e641a33dae4961196235bdb965b21b": "304148c109fef2979ed83fbc7cd0b006",
".git/objects/6a/8e24d7e372e568f08f1d63d529b5576964b04e": "d2ad6360eb970af274d75d77473a897f",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/69/993b97eb33f3a20ff55e8216dd5dbcc8fa5f48": "d60243a70b65af89f8e1dfb04fa626cd",
".git/objects/0b/7292d98a566a29419a3cc79ba98120d6e102bf": "b0b90c48cf351683b47c9499b493f587",
".git/objects/60/28d1cec5210fe17af158704f9c20d6c9e21486": "bea210ec99cb47f41c0f2830122797a8",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/05/24cf2b08239384ab3b6f0c8c0b2e5b57863000": "6c8c1a42f5f642ea71ca3874e4ab12d0",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/ac/485b4ab8b573ff5593af2de4dcdbbe15d65756": "9104aa4a9ed2f441682c9ba6a15dbfe2",
".git/objects/bb/8ebf81be4c0e43ad3db66f376088d4da4cfcd4": "781c7440ba926085a52ff8544ed14e8b",
".git/objects/d7/47ee7a5d2ebf6b3c3f1ffe888dfe380bc02755": "aab5c9062672dd752244d8d72671473e",
".git/objects/d0/5d19c8cfac1334d2134830bfd15b0129036f7c": "23f69ac1c83744cc845040341e78181e",
".git/objects/df/b2f3b7b17febca663a8aab99a087e0e0864830": "64196a0743a253111ec2124558b311bd",
".git/objects/df/74930a5b1ac12e06d8912e49c06c7b6d44e453": "01663f858e152d7b93430be11c0bf723",
".git/objects/a5/2807295a0d364261080b788ef1b0f3dd7e2978": "e96d575862c5c5b8dbd1de7af07b012e",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/bd/6be43d015a2a8a92db341ee519feb383a20cb4": "0df4c80430aff6e9b0cdd970bc215545",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/bc/3178c14e03c3429aaacdb71c6df846aab43120": "1304d4ca121e5d288693ab9f67d1571f",
".git/objects/d8/95855a1c21a8e316f992095b3882fa7369cfa9": "fe610db011a0d0a6a68ddad6931dc83c",
".git/objects/ab/d4e0ec72abd94549e813dcf76dfdce621d8286": "7dd935774bbd1393da0375e0121b78d3",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/eb/1287da971f8dfc84f358fe282d05aa7e151735": "486acb83461dd7d391473e48a24e4d62",
".git/objects/c9/8d9c769f2c5019d1f483e237364a87854fe15b": "cbb8f58dfcec326c64eaae76f606a4aa",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/e4/91a8771c779818ba8d96448d380ed971e8767a": "3267f5c90f57c81bb791dcf8fd9ba73c",
".git/objects/c8/3b43055e4323322108b6ac728b9c1d7b4e9a87": "c91d1de8255fe3764f50c7d6dc2ca170",
".git/objects/fb/417a030aee47a382131f766278965f8204ab3b": "1b8b30ade7ebe35d1bfbc34334434cc8",
".git/objects/ec/2565d8a6197e2bc2fdd3ce65f7a20a8fb4ad99": "66e479ac0fd5e10aea877187d63fdf70",
".git/objects/1f/ea86e9ee30ee98ee74f75fec9b708ba4c3a72a": "8cf197c9ae072f6fc1bb933d67d0a2e8",
".git/objects/28/2fa67b5d85da2b944cbc246cfa0485b89eb969": "59a34ad339eebb367ed95534f1b005f0",
".git/objects/17/f45bd0246d2d539295cce15ee818bd02ba9b9c": "e034d2f762b6cb744b556b4a531d3f82",
".git/objects/8f/368292a70675725b4d450fb31a7af7e7a2465c": "f772b016eabfd2336c517d3cfb18602d",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/26/5a1f4e9d7a0538bb03f97d3241c2f067186d25": "68b78eb0a0875a69ffb5c6d13b1c6e4a",
".git/objects/81/1ef0385a83cc2183344cbff92c178a0ec0d793": "5f86ee303aeb04264f8c1761c030465d",
".git/objects/86/d111f09a93cccfa0011858c519a823e7dafef7": "9a15839a59b5f501fbf7b9824c4b6f84",
".git/objects/72/e48869ca8b6ff08f95c8db6dd111216eb7ca6c": "44e1a2b33bdb702cecf5c86097008097",
".git/objects/2a/32da634650cea8d12bae528c9831339d36879b": "1ce16fdd6588f725f0bbbe9c7596c5c0",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/6e/ee8b273c93414175805a522e4e7a6ee67e5ff6": "1b5cdc08e26e88b2043156f560a09d4f",
".git/objects/9a/270a4c88df193b993648a9f290a3c31aec0aae": "c3e6fc0d2fb0afa71641cbe2a61a721a",
".git/objects/9a/18d412405b4cee202dcb9c96799eece5b3f8a8": "0eb4074f4d90ec1ffa80a1df33d3990d",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/65/4ec7d2536841f6f68e125143f444ae25d8ad22": "0404c08ebf9f16a3f4b43d230a152be1",
".git/objects/62/06943a9a02bffce762a6cd5d5096065826a068": "fbbef47a89d32fa896e2eb021d3ed233",
".git/objects/62/7ac4d5447a86c3c1ef3ff9907b76798ec3bf12": "e3413f19c2f318d849bd83913ef3f2c8",
".git/objects/3a/bf18c41c58c933308c244a875bf383856e103e": "30790d31a35e3622fd7b3849c9bf1894",
".git/objects/54/2e1206a636f66d255a33affdbbd3b42eab3ec5": "8e7fe5118c014b4b2253390cde04d0ef",
".git/objects/54/b4c756730b17bf75d8f05400fb5c668d3b7068": "3675abcddb92acdbcfc1b20110184b09",
".git/objects/6d/1c00f0edc7fca56b2ee16c81d0496801c3814e": "d44f08e58308bd0c248b6c53676931c9",
".git/objects/6c/8396f2482356d9824ed5bd47f26df5ee9e63f4": "faa96306f4c8d5069c5aadfe33179720",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/b8/56c819b5bf0628c916d9856b7f6c26989b0a73": "47e2b3ce0cf899e7466d69682886786c",
".git/objects/dd/c3d409cb93b424b2170dcca61172deb3566c1e": "d79a2ee35a29907c5433e134e7dff5fb",
".git/objects/dc/f83695f71da8c6278eb914cdd42692c427924e": "9ca7f32e12839dea4610032ada023058",
".git/objects/d2/6537c9c39e35341ad868e2dc20d99a9fedf8eb": "c58fab518b9817228c1b2ff2a12febcd",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/e67685e8e19f25ba96457cf89359f2a842233c": "bec73cbd41303a6171bbe4af4a4ebfe8",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/ef/795001c65ad56441219f3b76eef13b2d033a7f": "dcf4e3a4df3b21b92359eec2422bd10b",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/fa/b226d522bd61854e867718201323d8b0d62678": "c9fc869c1acbecb376ac293a556e2d16",
".git/objects/e7/af959b29a0cd80e4e01be9ad13678424168532": "9c7666cc0c3c291bb65acfd4da96d1a3",
".git/objects/cb/20ec1fef72696d89dc150fae04619ced306811": "141a53efcb16f330f164284154dcd7f6",
".git/objects/83/7a9eb24f62d7a9c5650d7c0d807a87fff50232": "51532e8c1910e9a6c9391d5f5d1ee356",
".git/objects/48/4ffe3f7b4175badefb89826ccd91e3b191aa3a": "efae046935bcbe1c4840371448070ee7",
".git/objects/70/4124fab22a7588cebaea7ff6372c7bf552a1ff": "0b7f886b73e390d55a78c86b2b3d98ca",
".git/objects/1e/ebdbf0e3f877cbea264ff1279aab8d33296611": "beb9a6453e49a35198544fa1b96dd634",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/12/a59302f7533535d7016bf94cdf1ec0fe3f48ad": "58bca12fc04a8d2c23fa5ecf5eda931a",
".git/objects/76/eed2a04ff3ba2ee2d0cb8062e55e6fa3bb832f": "af67d9083a8c2bcf20c6ef469f1dceae",
".git/objects/1c/1acb07b1a9d552a05ddee2e2224601f7c6ef46": "35d1fa8239504cc8d776c274ac4310a7",
".git/objects/49/6a11383558e9dc08f196a667c90a679e3cc9d5": "9279e9c9ce57c80b3875107f2509f3d5",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/8b/508571e060f4bfc12cfb3180b723b2ece4b586": "b052a70653e6ab862fc4c8029136d365",
".git/objects/8e/9f1e5680bf29a984b477724859b1d6cfb385b6": "e12a762f676e276f5e10da4333fc87bd",
".git/objects/8e/7646630e082f6697ca74ca44d857c869c1ef33": "fe6ed989349aa86bb2c7773c26075e01",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "a993c146c9acf7861fde59808d8044ae",
".git/logs/refs/heads/gh-pages": "4253e3da02837a9981f279f427e20bfe",
".git/logs/refs/remotes/origin/gh-pages": "3057d171dc7db9fbe5fd7bc9e68141fb",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "e0b5b08e209fa15f48d796e8976bc42b",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "5c90c1740b0cacecb469934e16fe8cb6",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/gh-pages": "7aa37da20f654df0ca66d8ac64d34232",
".git/refs/remotes/origin/gh-pages": "7aa37da20f654df0ca66d8ac64d34232",
".git/index": "eabf83e0a56c265e301a7ea7e8f8f32a",
".git/COMMIT_EDITMSG": "a01b2161c48c9454386e67e00c5c1c23",
".git/FETCH_HEAD": "97660457b48ed3506364bf55c0d3e9b1",
"assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/NOTICES": "649051f986b7a4523e0ccbf52d854b33",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin.json": "a1fee2517bf598633e2f67fcf3e26c94",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "0b0a3415aad49b6e9bf965ff578614f9",
"assets/fonts/MaterialIcons-Regular.otf": "49577d19806ce4f6ab5df0e7356a9451",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
  for (var resourceKey of Object.keys(RESOURCES)) {
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
