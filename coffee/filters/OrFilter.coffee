define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class OrFilter extends FindObjectFilter
    constructor: (filters...) ->
      super
      @setOperator 'or'
      @addFilter filters