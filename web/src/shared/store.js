const isChromeApp = window.chrome != null;

export default {
  fetch (key) {
    return new Promise((resolve) => {
      if (!isChromeApp) { return resolve(localStorage[key]); }

      window.chrome.storage.local.get(key, (data) => {
        resolve(data[key]);
      });
    }).then(value => JSON.parse(value || 'null'));
  },

  save (key, value) {
    return new Promise((resolve) => {
      if (!isChromeApp) {
        localStorage[key] = JSON.stringify(value);
        return resolve(value);
      }

      const data = { [key]: JSON.stringify(value) };
      window.chrome.storage.local.set(data, resolve);
    });
  },
};
