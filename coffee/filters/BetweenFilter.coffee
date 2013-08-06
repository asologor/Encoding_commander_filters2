define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class BetweenFilter extends FindObjectFilter
    constructor: (propertyName, operand1, operand2) ->
      super
      @setOperator 'between'
      @setPropertyName propertyName
      @setOperand1 operand1
      @setOperand2 operand2