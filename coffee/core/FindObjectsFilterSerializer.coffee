define ['underscore',
        'core/FindObjectsFilter',
        'core/ParsedString'],
(_, FindObjectFilter, ParsedString) ->
  class FindObjectFilterSerializer
    @FILTER_SEPARATOR: '-' # top level list of filters
    @ARGUMENT_SEPARATOR: '*'
    @LIST_BEGIN: '_'
    @LIST_CONTINUE: '-' # inside a list
    @LIST_END: '_'
    @ESCAPE: '.'

    @AbbreviatedOperator:
      and: "an"
      between: "bt"
      contains: "ct"
      equals: "eq"
      greaterOrEqual: "ge"
      greaterThan: "gt"
      in: "in"
      isNotNull: "nN"
      isNull: "iN"
      lessOrEqual: "le"
      lessThan: "lt"
      like: "lk"
      not: "nt"
      notEqual: "ne"
      notLike: "nl"
      or: "or"
      ENCODED_LENGTH: 2

    @Intrinsic:
      abortedBy:         "_aB"
      abortStatus:       "_aS"
      createTime:        "_cT"
      credentialName:    "_cN"
      directoryName:     "_dN"
      elapsedTime:       "_eT"
      errorCode:         "_eC"
      errorMessage:      "_eM"
      finish:            "_fn"
      jobId:             "_jI"
      jobName:           "_jN"
      lastModifiedBy:    "_lM"
      launchedByUser:    "_lB"
      licenseWaitTime:   "_lW"
      liveProcedure:     "_lP"
      liveSchedule:      "_lS"
      modifyTime:        "_mT"
      outcome:           "_oc"
      owner:             "_ow"
      priority:          "_pr"
      procedureName:     "_pc"
      projectName:       "_pj"
      resourceWaitTime:  "_rW"
      runAsUser:         "_rU"
      scheduleName:      "_sc"
      start:             "_sr"
      stateName:         "_sN"
      status:            "_st"
      totalWaitTime:     "_tW"
      workspaceWaitTime: "_wW"

    @encodeOperator: (operator) ->
      @AbbreviatedOperator[operator]

    @encodePropertyName: (propertyName) ->
      @Intrinsic[propertyName]

    @decodeOperator: (operator) ->
      for key, value of @AbbreviatedOperator
        if value == operator
          return key
      null

    @decodePropertyName: (propertyName) ->
      for key, value of @Intrinsic
        if value == propertyName
          return key
      null

    @serializeString: (sb, s) ->
      for c in s
        switch c
          when @FILTER_SEPARATOR, @ARGUMENT_SEPARATOR, @LIST_BEGIN, @ESCAPE
            sb.push @ESCAPE
            sb.push c
            break
          else
            sb.push c
            break

    @deserializeString: (s) ->
      sb = new Array()
      begin = s.idx

      while s.idx < s.str.length
        c = s.str.charAt s.idx

        switch c
          when @ARGUMENT_SEPARATOR, @LIST_CONTINUE, @LIST_END
            return sb.join ''

          when @ESCAPE
            if s.idx == s.str.length - 1
              console.log 'Malformed escape at ' + s.str.substring begin

            c = s.str.charAt ++s.idx
            sb.push c
            ++s.idx
            break

          else
            sb.push c
            ++s.idx
            break
      sb.join ''


    @serialize: (filters) ->
      sb = new Array()
      for f in filters
        if sb.length > 0
          sb.push @FILTER_SEPARATOR
        @serialize2 sb, f
      sb.join('')

    @serialize2: (sb, f) ->
      unless f instanceof FindObjectFilter
        @serializeString sb, f
        return null

      op = f.getParameter 'operator'

      sb.push @encodeOperator op

      switch op
        when 'and', 'or', 'not'
          sb.push @LIST_BEGIN
          filters = f.getMultiValuedParameter 'filter'
          #console.log sb.join ''
          unless filters?
            sb.push @LIST_END
            break

          first = true
          for object in filters
            unless object instanceof FindObjectFilter
              console.log 'unexpected object type'

            #console.log object
            #console.log object.getParameter 'operator'
            unless first
              sb.push @LIST_CONTINUE

            @serialize2 sb, object
            first = false

          sb.push @LIST_END

        else
          sb.push @ARGUMENT_SEPARATOR

          propertyName = f.getStringParameter 'propertyName'
          i_encoded = @encodePropertyName propertyName
          if i_encoded?
            @serializeString sb, i_encoded
          else
            @serializeString sb, propertyName

          if op == 'isNull' or op == 'isNotNull'
            break

          sb.push @ARGUMENT_SEPARATOR
          @serialize2 sb, f.getParameter 'operand1'

          unless op == 'between'
            break

          sb.push @ARGUMENT_SEPARATOR
          @serialize2 sb, f.getParameter 'operand2'
          break

    @deserialize: (serialized, filters) ->
      s = new ParsedString serialized

      while s.idx < serialized.length
        if s.idx > 0
          s.check @FILTER_SEPARATOR, 'Malformed filter list'

        filters.push @deserialize2 s
      filters

    @deserialize2: (s)->
      if s.str.charAt(s.idx) == @LIST_END
        return null

      if s.str.length < (s.idx + @AbbreviatedOperator.ENCODED_LENGTH + 1)
        console.log 'Malformed filter at ' + s.str.substring s.idx

      op = s.str.substring s.idx, s.idx + @AbbreviatedOperator.ENCODED_LENGTH
      s.idx += @AbbreviatedOperator.ENCODED_LENGTH

      o = @decodeOperator op

      unless o?
        console.log 'Couldn\'t locate operator "' + op + '"'

      f = new FindObjectFilter()
      f.setOperator o

      switch o
        when 'and', 'or', 'not'
          first = true

          s.check @LIST_BEGIN, 'Malformed "' + o + '" filter list'

          while true
            unless first
              ++s.idx
            child = @deserialize2 s

            if child?
              f.addFilter child

            first = false

            if s.str.charAt(s.idx) != @LIST_CONTINUE
              break

          s.check @LIST_END, 'Malformed "' + o + '" filter termination'
          break

        else
          s.check @ARGUMENT_SEPARATOR, 'Malformed "' + o + '" parameterName'

          arg = @deserializeString s
          intrinsic = @decodePropertyName arg

          if intrinsic?
            f.setPropertyName intrinsic
          else
            f.setPropertyName arg

          if o == 'isNull' or o == 'isNotNull'
            break

          s.check @ARGUMENT_SEPARATOR, 'Malformed "' + o + '" operand1'
          arg = @deserializeString s
          f.setOperand1 arg

          unless o == 'between'
            break

          s.check @ARGUMENT_SEPARATOR, 'Malformed "' + o + '" operand2'
          arg = @deserializeString s
          f.setOperand2 arg
          break

      f