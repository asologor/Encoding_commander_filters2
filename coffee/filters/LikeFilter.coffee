define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class LikeFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'like'
      @setPropertyName propertyName
      @setOperand1 operand