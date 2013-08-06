define ->
  class ParsedString
    str: ''
    idx: 0

    constructor: (s)->
      @str = s
      @idx = 0

    check: (c, complaint) ->
      if @str.charAt(@idx) != c
        console.log complaint + ' at ' + @str.substring @idx
      ++@idx