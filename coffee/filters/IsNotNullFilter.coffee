define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class IsNotNullFilter extends FindObjectFilter
    constructor: (propertyName) ->
      super
      @setOperator 'isNotNull'
      @setPropertyName propertyName