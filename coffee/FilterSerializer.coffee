define ['core/FindObjectsFilterSerializer'
        'filters/ContainsFilter',
        'filters/EqualsFilter',
        'filters/NotEqualFilter',
        'filters/GreaterThanFilter'],
(FindObjectsFilterSerializer, ContainsFilter,
   EqualsFilter, NotEqualFilter, GreaterThanFilter) ->
  class FilterSerializer
    @QUICKSEARCH: 'qUiCkSeArCh'
    @RESOURCEAGENTSTATE: 'resourceAgentState'
    @RESOURCEDISABLED: 'resourceDisabled'
    @POOLS: 'pools'
    @STEPLIMIT: 'stepLimit'
    @PROXYHOSTNAME: 'proxyHostName'
    @HOSTNAME: 'hostName'

    @serialize: (filters) ->
      filterCollection = new Array()
      if filters['search']?
        filterCollection.push new EqualsFilter(@QUICKSEARCH, filters['search'])

      down = filters['status-down']
      up = filters['status-up']

      if down and not up
        filterCollection.push new EqualsFilter(@RESOURCEAGENTSTATE, 'down')

      if up and not down
        filterCollection.push new EqualsFilter(@RESOURCEAGENTSTATE, 'alive')

      if filters['status'] is 'enabled'
        isEnabledFilter = new EqualsFilter @RESOURCEDISABLED, filters['status']
        filterCollection.push isEnabledFilter

      if filters['pools']?
        poolsFilter = new ContainsFilter @POOLS, filters['pools']
        filterCollection.push poolsFilter

      if filters['hosts']?
        hostFilter = new EqualsFilter @HOSTNAME, filters['hosts']
        filterCollection.push hostFilter

      if filters['step-limit']?
        stepLimitFilter = new GreaterThanFilter @STEPLIMIT, filters['step-limit']
        filterCollection.push stepLimitFilter

      pa = filters['proxy-agent']
      if pa isnt 'no' and pa isnt 0 and pa isnt false
        if pa is 'true' or pa is 'yes' or pa is 1
          proxyFilter = new NotEqualFilter @PROXYHOSTNAME, ''
        else
          proxyFilter = new EqualsFilter @PROXYHOSTNAME, ''
        filterCollection.push proxyFilter

      serialized = FindObjectsFilterSerializer.serialize filterCollection

    @deserialize: (serialized) ->
      decoded = {
        'search': ''
        'status-down': false
        'status-up': false
        'status': ''
        'pools': ''
        'hosts': ''
        'step-limit': 0
        'proxy-agent': 0
      }
      deserialized = new Array()
      FindObjectsFilterSerializer.deserialize serialized, deserialized

      for d in deserialized
        propertyName = d.getStringParameter 'propertyName'

        switch propertyName
          when @QUICKSEARCH
            decoded['search'] = d.getStringParameter 'operand1'
            break
          when @RESOURCEAGENTSTATE
            if (d.getStringParameter 'operand1') is 'down'
              decoded['status-down'] = true
              decoded['status-up'] = false
            else if (d.getStringParameter 'operand1') is 'alive'
              decoded['status-down'] = false
              decoded['status-up'] = true
            break
          when @RESOURCEDISABLED
            decoded['status'] = d.getStringParameter 'operand1'
            break
          when @POOLS
            decoded['pools'] = d.getStringParameter 'operand1'
            break
          when @STEPLIMIT
            sl = d.getStringParameter 'operand1'
            decoded['step-limit'] = parseInt sl
            break
          when @PROXYHOSTNAME
            if (d.getStringParameter 'operator') is 'notEqual'
              decoded['proxy-agent'] = 1
            break
          when @HOSTNAME
            decoded['hosts'] = d.getStringParameter 'operand1'
            break
      decoded