define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class ContainsFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'contains'
      @setPropertyName propertyName
      @setOperand1 operand