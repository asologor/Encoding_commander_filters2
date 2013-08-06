define ['underscore'], (_) ->
  class CommanderRequestFragment
    m_requestParams: {}

    constructor: ->
      @m_requestParams = new Object()

    addParameter: (name, value) ->
      @doAddParameter name, value

    doAddParameter: (name, value) ->
      curValue = @m_requestParams[name]
      unless curValue?
        @m_requestParams[name] = value
        return

      unless _.isArray curValue
        arr = new Array()
        arr.push @m_requestParams[name]
        arr.push value
        @m_requestParams[name] = arr
        return

      @m_requestParams[name].push value
      null

    doSetParameter: (name, value) ->
      @m_requestParams[name] = value

    getMultiValuedParameter: (name) ->
      result = @m_requestParams[name]

      unless result?
        return null

      unless _.isArray result
        return [result]

      result

    getParameter: (name) ->
      @m_requestParams[name]

    getParameters: ->
      @m_requestParams

    getRequestParams: ->
      @m_requestParams

    getStringParameter: (name) ->
      result = @m_requestParams[name]

      unless _.isString result
        return null

      result

    setParameter: (name, value) ->
      #console.log "Setting parameter: #{name}: #{value}"
      if value instanceof CommanderRequestFragment
        @doSetParameter name, value
        return null

      unless value?
        @doSetParameter name, ''
        return null

      if _.isBoolean value
        @doSetParameter name, value ? '1':'0'
        return null

      if value?
        @doSetParameter name, value.toString()