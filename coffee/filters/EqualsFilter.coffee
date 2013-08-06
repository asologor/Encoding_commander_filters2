define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class EqualsFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'equals'
      @setPropertyName propertyName
      @setOperand1 operand