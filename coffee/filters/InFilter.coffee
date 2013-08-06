define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class InFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'in'
      @setPropertyName propertyName
      @setOperand1 operand.join(',')