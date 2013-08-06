define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class LessThanFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'lessThan'
      @setPropertyName propertyName
      @setOperand1 operand