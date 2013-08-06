define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class LessOrEqualFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'lessOrEqual'
      @setPropertyName propertyName
      @setOperand1 operand