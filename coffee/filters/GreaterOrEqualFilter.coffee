define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class GreaterOrEqualFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'greaterOrEqual'
      @setPropertyName propertyName
      @setOperand1 operand