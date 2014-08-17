React = require 'react'
RSVP = require 'rsvp'
store = require '../shared/store'
BoardList = require '../boards/board-list'

LS_KEY = 'scorekeeper'

debounce = (timeout, fn)->
  (args...)->
    context = this
    clearTimeout debounce.timeout
    debounce.timeout = setTimeout ->
      fn.call context, args...
    , timeout

module.exports = React.createClass

  render: ->
    BoardList
      boards: @state.boards
      onUpdate: @update

  getInitialState: ->
    boards: []

  componentDidMount: ->
    store.fetch(LS_KEY).then (data)=>
      @setState boards: data.boards or []

  update: (boards)->
    @save boards
    new RSVP.Promise (resolve)=>
      @setState boards: boards, resolve

  save: debounce 300, (boards)->
    store.save LS_KEY, boards: boards
