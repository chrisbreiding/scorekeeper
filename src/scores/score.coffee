React = require 'react'

module.exports = React.createClass

  render: ->
    React.DOM.div
      ref: 'container'
      className: 'score'
      onClick: @edit
    ,
      React.DOM.input
        ref: 'score'
        tabIndex: '-1'
        defaultValue: @props.score
        onKeyDown: @keyDown
        onKeyUp: @keyUp
        onFocus: @edit
        onBlur: @stopEditing
    ,
      React.DOM.button
        onClick: @remove
      ,
        '×'

  edit: (e)->
    e and e.stopPropagation()
    @refs.container.getDOMNode().className = 'score editing'
    @refs.score.getDOMNode().focus()

  stopEditing: ->
    @refs.container.getDOMNode().className = 'score'

  keyDown: (e)->
    return unless e.key is 'Tab'

    e.preventDefault()
    if e.shiftKey
      @props.onPreviousBoard()
    else
      @props.onNextBoard()

  keyUp: (e)->
    score = e.target.value
    @props.onUpdate
      id: @props.key
      score: score

    switch e.key
      when 'ArrowUp'
        @previousScore score
      when 'Enter', 'ArrowDown'
        @nextScore score

  previousScore: (score)->
    @props.onPrevious
      id: @props.key
      score: score

  nextScore: (score)->
    @props.onNext
      id: @props.key
      score: score

  remove: ->
    @props.onRemove id: @props.key
