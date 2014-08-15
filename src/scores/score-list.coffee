React = require 'react'
ListMixin = require '../shared/list-mixin'
Score = require './score'

module.exports = React.createClass

  mixins: [ListMixin]

  render: ->
    React.DOM.div
      className: 'scores'
      onClick: @edit
    ,
      @props.scores.map (score)=>
        Score
          key: score.id
          score: score.score
          ref: "score#{score.id}"
          onPrevious: @previousScore
          onNext: @nextOrNewScore
          onPreviousBoard: @props.onPreviousBoard
          onNextBoard: @props.onNextBoard
          onUpdate: @update
          onRemove: @remove

  componentWillMount: ->
    @listName = 'scores'

  edit: ->
    lastScore = @props.scores[@props.scores.length - 1]
    if lastScore and !lastScore.score.trim()
      @editScore lastScore
    else
      @editNewScore()

  editScore: (score)->
    @refs["score#{score.id}"].edit()

  previousScore: (score)->
    index = @indexOf score
    @editScore @props.scores[index - 1] if index > 0

  nextOrNewScore: (score)->
    nextScore = @props.scores[@indexOf(score) + 1]
    if score.score.trim()
      if nextScore
        @editScore nextScore
      else
        @editNewScore()

  editNewScore: ->
    @addScore().then (score)=> @editScore score

  addScore: ->
    score =
      id: @newId()
      score: ''
    @props.scores.push score
    @save().then -> score
