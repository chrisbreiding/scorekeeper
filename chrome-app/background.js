chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('index.html', {
    id: 'ScoreKeeperWindow',
    bounds: {
      width: 800,
      height: 600
    },
    minWidth: 400,
    minHeight: 300
  });
});
