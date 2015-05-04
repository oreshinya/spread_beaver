module.exports =
  clear: ->
    @_store = {}

  execFromServerSide: (data) ->
    for d in data
      @_store[d.id] = d

  all: ->
    result = []
    for id of @_store
      result.push @_store[id]
    result
