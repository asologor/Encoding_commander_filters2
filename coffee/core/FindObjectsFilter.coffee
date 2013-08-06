define ['underscore',
        'core/CommanderRequestFragment'],
(_, CommanderRequestFragment) ->
  class FindObjectFilter extends CommanderRequestFragment
    ###
    @Operator: [
      'and'
      'between'
      'contains'
      'equals'
      'greaterOrEqual'
      'greaterThan'
      'in'
      'isNotNull'
      'isNull'
      'lessOrEqual'
      'lessThan'
      'like'
      'not'
      'notEqual'
      'notLike'
      'or'
    ]
    ###

    constructor: ->
      super

    addFilter: (filters...) ->
      for f in filters
        @addParameter 'filter', f
      @

    nullToEmpty: (str) ->
      unless str?
        console.log 'nullToEmpty'
        return ''
      str

    setOperand1: (operand1) ->
      @setParameter 'operand1', @nullToEmpty operand1
      @

    setOperand2: (operand2) ->
      @setParameter 'operand2', @nullToEmpty operand2
      @

    setOperator: (operator) ->
      @setParameter 'operator', operator

    setPropertyName: (propertyName) ->
      @setParameter 'propertyName', propertyName
      @

    setDateOperand1: (operand1) ->
      @setParameter 'displayOperand1', @nullToEmpty operand1
      @

    setDateOperand2: (operand2) ->
      @setParameter 'displayOperand2', @nullToEmpty operand2
      @

    ###
    class AndFilter extends FindObjectFilter
      constructor: (filters...) ->
        super
        @setOperator 'and'
        @addFilter filters

    class BetweenFilter extends FindObjectFilter
      constructor: (propertyName, operand1, operand2) ->
        super
        @setOperator 'between'
        @setPropertyName propertyName
        @setOperand1 operand1
        @setOperand2 operand2

    class ContainsFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'contains'
        @setPropertyName propertyName
        @setOperand1 operand

    class EqualsFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'equals'
        @setPropertyName propertyName
        @setOperand1 operand

    class GreaterOrEqualFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'greaterOrEqual'
        @setPropertyName propertyName
        @setOperand1 operand

    class GreaterThanFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'greaterThan'
        @setPropertyName propertyName
        @setOperand1 operand

    class InFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'in'
        @setPropertyName propertyName
        @setOperand1 operand

    class IsNotNullFilter extends FindObjectFilter
      constructor: (propertyName) ->
        super
        @setOperator 'isNotNull'
        @setPropertyName propertyName



    class LessOrEqualFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'lessOrEqual'
        @setPropertyName propertyName
        @setOperand1 operand

    class LessThanFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'lessThan'
        @setPropertyName propertyName
        @setOperand1 operand

    class LikeFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'like'
        @setPropertyName propertyName
        @setOperand1 operand

    class NotEqualFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'notEqual'
        @setPropertyName propertyName
        @setOperand1 operand

    class NotFilter extends FindObjectFilter
      constructor: (filter) ->
        super
        @setOperator 'not'
        @addFilter filter

    class NotLikeFilter extends FindObjectFilter
      constructor: (propertyName, operand) ->
        super
        @setOperator 'notLike'
        @setPropertyName propertyName
        @setOperand1 operand

    class OrFilter extends FindObjectFilter
      constructor: (filter) ->
        super
        @setOperator 'or'
        @addFilter filter

    class IsNullFilter extends FindObjectFilter
      constructor: (propertyName) ->
        super
        @setOperator 'isNull'
        @setPropertyName propertyName
    ###