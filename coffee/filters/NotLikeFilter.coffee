define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class NotLikeFilter extends FindObjectFilter
    constructor: (propertyName, operand) ->
      super
      @setOperator 'notLike'
      @setPropertyName propertyName
      @setOperand1 operand