define ['../core/FindObjectsFilter'], (FindObjectFilter) ->
  class NotFilter extends FindObjectFilter
    constructor: (filter) ->
      super
      @setOperator 'not'
      @addFilter filter