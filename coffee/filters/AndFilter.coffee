define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class AndFilter extends FindObjectFilter
    constructor: (filters...) ->
      super
      @setOperator 'and'
      @addFilter filters