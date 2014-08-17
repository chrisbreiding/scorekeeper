RSVP = require 'rsvp'

isChromeApp = window.chrome?

module.exports =

  fetch: (key)->
    new RSVP.Promise (resolve)->
      if isChromeApp
        chrome.storage.local.get key, (data)->
          resolve JSON.parse data[key]
      else
        resolve JSON.parse(localStorage[key] or 'null')

  save: (key, value)->
    new RSVP.Promise (resolve)->
      if isChromeApp
        data = {}
        data[key] = JSON.stringify value
        chrome.storage.local.set data, resolve
      else
        localStorage[key] = JSON.stringify value
        resolve value
