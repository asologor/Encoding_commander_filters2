define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class NotEqualFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'notEqual'
      @setPropertyName propertyName
      @setOperand1 operand