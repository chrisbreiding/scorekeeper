module.exports =

  indexOf: (item)->
    for thisOne, index in @props[@listName]
      return index if thisOne.id is item.id
    -1

  newId: ->
    ids = (item.id for item in @props[@listName])
    return 0 unless ids.length
    Math.max(ids...) + 1

  update: (item)->
    @replace item, item

  remove: (item)->
    @replace item

  replace: (item, replacement)->
    index = @indexOf item
    if index > -1
      args = [index, 1]
      args.push replacement if replacement
      @props[@listName].splice args...
      @save()

  save: ->
    @props.onUpdate @props[@listName]
