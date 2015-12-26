React = require 'react'
ListMixin = require '../shared/list-mixin'
Board = require './board'

module.exports = React.createClass

  mixins: [ListMixin]

  render: ->
    React.DOM.div
      className: 'board-list'
    ,
      React.DOM.div
        className: 'boards'
      ,
        @props.boards.map (board)=>
          Board
            key: board.id
            name: board.name
            scores: board.scores
            ref: "board#{board.id}"
            onUpdate: @update
            onRemove: @remove
            onPreviousBoard: @previousBoard
            onNextBoard: @nextBoard
    ,
      React.DOM.button
        className: 'plus'
        onClick: @newBoard
      ,
        '+'

  componentWillMount: ->
    @listName = 'boards'

  newBoard: ->
    @props.boards.push
      id: @newId()
      name: ''
      scores: []
    @save()

  previousBoard: (board)->
    @moveToBoard board, (index)=>
      if index - 1 < 0 then @props.boards.length - 1 else index - 1

  nextBoard: (board)->
    @moveToBoard board, (index)=>
      if index + 1 > @props.boards.length - 1 then 0 else index + 1

  moveToBoard: (board, moveToIndex)->
    index = @indexOf board
    @edit @props.boards[moveToIndex index] if index > -1

  edit: (board)->
    @refs["board#{board.id}"].edit()
