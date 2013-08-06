#Tests for all types of filters

define ['core/FindObjectsFilterSerializer',
        'filters/IsNullFilter',
        'filters/IsNotNullFilter',
        'filters/ContainsFilter',
        'filters/EqualsFilter',
        'filters/NotEqualFilter',
        'filters/GreaterOrEqualFilter',
        'filters/GreaterThanFilter',
        'filters/LessOrEqualFilter',
        'filters/LessThanFilter',
        'filters/LikeFilter',
        'filters/NotLikeFilter',
        'filters/InFilter',
        'filters/BetweenFilter',
        'filters/AndFilter',
        'filters/OrFilter',
        'filters/NotFilter',
        'FilterSerializer'],
  (FindObjectFilterSerializer, IsNullFilter
   IsNotNullFilter, ContainsFilter, EqualsFilter,
   NotEqualFilter, GreaterOrEqualFilter,
   GreaterThanFilter, LessOrEqualFilter,
   LessThanFilter, LikeFilter, NotLikeFilter,
   InFilter, BetweenFilter, AndFilter,
   OrFilter, NotFilter, FilterSerializer) ->
    class App
      FOO: 'foo'
      BAR: 'bar'
      BAZ: 'baz'
      ESCAPEE: 'a.b-c*d_e'

      filters:
        'search': 'test search'
        'status-down': true
        'status-up': false
        'status': 'enabled'
        'pools': 'pools names'
        'hosts': 'hosts names'
        'step-limit': 10
        'proxy-agent': 'no'

      start: ->
        serialized = FilterSerializer.serialize @filters
        console.log serialized
        decoded = @deserialize serialized
        console.log decoded

        decoded = FilterSerializer.deserialize serialized
        console.log decoded

        ###
        console.log '----------encoding----------'
        simple = new IsNullFilter @FOO
        encoded = @serialize simple
        console.log encoded # 'iN*foo'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'isNull'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'

        console.log '----------encoding----------'
        simple = new IsNotNullFilter @FOO
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'nN*foo'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'isNotNull'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'

        # 1 operand
        console.log '----------encoding----------'
        simple = new ContainsFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'ct*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'contains'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new EqualsFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'eq*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'equals'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new NotEqualFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'ne*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'notEqual'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new GreaterOrEqualFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'ge*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'greaterOrEqual'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new GreaterThanFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'gt*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'greaterThan'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new LessOrEqualFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'le*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'lessOrEqual'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new LessThanFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'lt*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'lessThan'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new LikeFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'lk*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'like'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        console.log '----------encoding----------'
        simple = new NotLikeFilter @FOO, @BAR
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'nl*foo*bar'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'notLike'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'

        values = new Array()
        values.push @FOO
        values.push @BAR
        values.push @BAZ

        console.log '----------encoding----------'
        simple = new InFilter @FOO, values
        console.log simple
        encoded = @serialize simple
        console.log encoded # 'in*foo*foo,bar,baz'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'in'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'foo,bar,baz'

        # 2 operands
        console.log '----------encoding----------'
        simple2 = new BetweenFilter @FOO, @BAR, @BAZ
        encoded = @serialize simple2
        console.log encoded # 'bt*foo*bar*baz'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'between'
        console.log decoded[0].getStringParameter 'propertyName' # 'FOO'
        console.log decoded[0].getStringParameter 'operand1' # 'BAR'
        console.log decoded[0].getStringParameter 'operand2' # 'BAZ'

        # Boolean filters
        console.log '----------encoding----------'
        complex = new AndFilter()
        complex.addFilter simple, simple2
        console.log complex
        encoded = @serialize complex
        console.log encoded # 'an_in*foo*foo,bar,baz-bt*foo*bar*baz_'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'and'

        console.log '----------encoding----------'
        complex = new OrFilter()
        complex.addFilter simple, simple2
        console.log complex
        encoded = @serialize complex
        console.log encoded # 'or_in*foo*foo,bar,baz-bt*foo*bar*baz_'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'or'

        console.log '----------encoding----------'
        complex = new NotFilter simple2
        console.log complex
        encoded = @serialize complex
        console.log encoded # 'nt_bt*foo*bar*baz_'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'not'

        @test_escaping()
        @test_intrinsics()
        @test_multiple_filters()
        @test_nested_filters()
        @test_weird_cases()
        ###

      test_escaping: ->
        console.log '----------test escaping----------'
        and_ = new AndFilter(new BetweenFilter(@ESCAPEE, @ESCAPEE, @ESCAPEE),
          new BetweenFilter(@ESCAPEE, @ESCAPEE, @ESCAPEE)
        )
        console.log and_
        encoded = @serialize and_
        console.log encoded

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log @getOperator decoded[0] # 'and'

        children = @getFilters decoded[0]
        console.log children.length # 2
        console.log children[0].getStringParameter 'propertyName' # ESCAPEE
        console.log children[0].getStringParameter 'operand1' # ESCAPEE
        console.log children[0].getStringParameter 'operand2' # ESCAPEE
        console.log children[1].getStringParameter 'propertyName' # ESCAPEE
        console.log children[1].getStringParameter 'operand1' # ESCAPEE
        console.log children[1].getStringParameter 'operand2' # ESCAPEE

      test_intrinsics: ->
        console.log '----------test intrinsics----------'
        for key, value of FindObjectFilterSerializer.Intrinsic
          console.log '----------encoding----------'
          console.log 'Key: ' + key
          filter = new IsNullFilter key
          encoded = @serialize filter
          console.log 'Encoded: ' + encoded

          console.log '---------decoding----------'
          decoded = @deserialize encoded
          console.log '----------result----------'
          console.log 'Decoded operator: ' + @getOperator decoded[0] # 'isNull'
          console.log 'Decoded property: ' + decoded[0].getStringParameter 'propertyName'

      test_multiple_filters: ->
        impossible1 = new AndFilter( new LessThanFilter(@FOO, '0'),
          new GreaterThanFilter(@FOO, '0')
        )
        console.log impossible1
        impossible2 =  new AndFilter( new IsNullFilter(@FOO),
          new IsNotNullFilter(@FOO)
        )
        console.log impossible2

        filters = new Array()
        filters.push impossible1
        filters.push impossible2

        encoded = FindObjectFilterSerializer.serialize filters
        console.log encoded # 'an_lt*foo*0-gt*foo*0_-an_iN*foo-nN*foo_'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 2
        console.log @getOperator decoded[0] # 'and'
        console.log @getOperator decoded[1] # 'and'

      test_nested_filters: ->
        console.log '----------test_nested_filters----------'
        impossible1 = new AndFilter( new LessThanFilter(@FOO, '0'),
          new GreaterThanFilter(@FOO, '0')
        )
        console.log impossible1
        impossible2 =  new AndFilter( new IsNullFilter(@FOO),
          new IsNotNullFilter(@FOO)
        )
        console.log impossible2
        or_ = new OrFilter impossible1, impossible2
        console.log or_

        encoded = @serialize or_
        console.log encoded # 'or_an_lt*foo*0-gt*foo*0_-an_iN*foo-nN*foo__'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log @getOperator decoded[0] # 'or'

        console.log '----------children----------'
        children = @getFilters decoded[0]

        console.log @getOperator children[0] # 'and'
        console.log @getOperator children[1] # 'and'

        console.log '----------grandchildren----------'
        grandchildren = @getFilters children[0]
        console.log @getOperator grandchildren[0] # 'lessThan'
        console.log @getOperator grandchildren[1] # 'greaterThan'
        grandchildren = @getFilters children[1]
        console.log @getOperator grandchildren[0] # 'isNull'
        console.log @getOperator grandchildren[1] # 'isNotNull'

      test_weird_cases: ->
        console.log '----------test_weird_cases----------'
        and_ = new AndFilter()
        encoded = @serialize and_
        console.log encoded # 'an__'

        console.log '---------decoding----------'
        decoded = @deserialize encoded
        console.log '----------result----------'
        console.log decoded.length # 1
        console.log @getOperator decoded[0] # 'and'
        console.log decoded[0].getMultiValuedParameter 'filter' # null

      serialize: (f)->
        l = new Array()
        l.push f
        FindObjectFilterSerializer.serialize l

      deserialize: (s)->
        l = new Array()
        FindObjectFilterSerializer.deserialize s, l
        l

      getOperator: (f)->
        f.getStringParameter 'operator'

      getFilters: (f) ->
        filters = f.getMultiValuedParameter 'filter'
        filters
