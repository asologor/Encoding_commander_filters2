define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class IsNullFilter extends FindObjectFilter
    constructor: (propertyName) ->
      super
      @setOperator 'isNull'
      @setPropertyName propertyName