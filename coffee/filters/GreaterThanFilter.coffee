define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class GreaterThanFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'greaterThan'
      @setPropertyName propertyName
      @setOperand1 operand