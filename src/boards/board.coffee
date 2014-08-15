React = require 'react'
ScoreList = require '../scores/score-list'

module.exports = React.createClass

  render: ->
    total = this.props.scores.reduce (total, score)->
      total += +score.score unless isNaN +score.score
      total
    , 0

    React.DOM.div
      className: 'board'
    ,
      React.DOM.input
        ref: 'name'
        className: 'name'
        placeholder: 'name...'
        tabIndex: '1'
        defaultValue: @props.name
        onKeyUp: @updateName
    ,
      React.DOM.button
        className: 'close'
        onClick: @remove
      ,
        React.DOM.span null, '×'
    ,
      ScoreList
        ref: 'scoreList'
        scores: @props.scores
        onUpdate: @updateScores
        onPreviousBoard: @previousBoard
        onNextBoard: @nextBoard
    ,
      React.DOM.div
        className: 'total'
      ,
        React.DOM.span null, total
      ,
        React.DOM.button
          onClick: @clearScores
        ,
          React.DOM.span null, '⊝'

  componentDidMount: ->
    if !@props.name.trim()
      @refs.name.getDOMNode().focus()

  updateName: (e)->
    @props.name = e.target.value
    @save()

  updateScores: (scores)->
    @props.scores = scores
    @save()

  clearScores: ->
    @props.scores = []
    @save()

  remove: ->
    @props.onRemove id: @props.key

  previousBoard: ->
    @props.onPreviousBoard id: @props.key

  nextBoard: ->
    @props.onNextBoard id: @props.key

  edit: ->
    @refs.scoreList.edit()

  save: ->
    @props.onUpdate
      id: @props.key
      name: @props.name
      scores: @props.scores
