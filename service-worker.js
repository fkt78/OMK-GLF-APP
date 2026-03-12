// ===== Service Worker for Golf Game PWA =====
// キャッシュ名にバージョンを付与。更新時はここを変更するとキャッシュが更新される
const CACHE_NAME = 'golf-game-v3';

// 静的アセット（画像・マニフェスト）のみキャッシュ対象とする
// HTMLはネットワーク優先にするためここには含めない
const urlsToCache = [
  '/OMK-GLF-APP/manifest.json',
  '/OMK-GLF-APP/icon-192.png',
  '/OMK-GLF-APP/icon-512.png',
];

// インストール時：静的アセットをキャッシュに保存
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('[SW] キャッシュ登録中...');
        return cache.addAll(urlsToCache);
      })
      .then(() => {
        return self.skipWaiting();
      })
  );
});

// アクティベート時：古いキャッシュを削除
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(name => name !== CACHE_NAME)
          .map(name => {
            console.log('[SW] 古いキャッシュを削除:', name);
            return caches.delete(name);
          })
      );
    }).then(() => {
      return self.clients.claim();
    })
  );
});

// フェッチ時：HTMLはネットワーク優先（常に最新版を取得）、それ以外はキャッシュ優先
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);

  // HTMLファイルはネットワーク優先：常に最新版を取得し、失敗時のみキャッシュにフォールバック
  if (event.request.destination === 'document' || url.pathname.endsWith('.html')) {
    event.respondWith(
      fetch(event.request)
        .then(response => {
          if (response && response.status === 200) {
            const responseToCache = response.clone();
            caches.open(CACHE_NAME).then(cache => {
              cache.put(event.request, responseToCache);
            });
          }
          return response;
        })
        .catch(() => {
          return caches.match(event.request)
            .then(cached => cached || caches.match('/OMK-GLF-APP/golf-game.html'));
        })
    );
    return;
  }

  // 画像・マニフェスト等の静的アセットはキャッシュ優先
  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {
        if (cachedResponse) {
          return cachedResponse;
        }
        return fetch(event.request).then(response => {
          if (!response || response.status !== 200 || response.type !== 'basic') {
            return response;
          }
          const responseToCache = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseToCache);
          });
          return response;
        });
      })
      .catch(() => {
        return caches.match('/OMK-GLF-APP/golf-game.html');
      })
  );
});
