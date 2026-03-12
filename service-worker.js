const CACHE_NAME = 'golf-game-v1';
const urlsToCache = [
  '/OMK-GLF-APP/golf-game.html',
  '/OMK-GLF-APP/manifest.json',
  '/OMK-GLF-APP/icon-192.png',
  '/OMK-GLF-APP/icon-512.png',
];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(urlsToCache)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(names => Promise.all(
    names.filter(n => n !== CACHE_NAME).map(n => caches.delete(n))
  )).then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request).then(r => r || fetch(e.request).then(res => {
      if (!res || res.status !== 200) return res;
      const clone = res.clone();
      caches.open(CACHE_NAME).then(c => c.put(e.request, clone));
      return res;
    })).catch(() => caches.match('/OMK-GLF-APP/golf-game.html'))
  );
});
