// Generated by CoffeeScript 1.6.3
define(['underscore', 'core/FindObjectsFilter', 'core/ParsedString'], function(_, FindObjectFilter, ParsedString) {
  var FindObjectFilterSerializer;
  return FindObjectFilterSerializer = (function() {
    function FindObjectFilterSerializer() {}

    FindObjectFilterSerializer.FILTER_SEPARATOR = '-';

    FindObjectFilterSerializer.ARGUMENT_SEPARATOR = '*';

    FindObjectFilterSerializer.LIST_BEGIN = '_';

    FindObjectFilterSerializer.LIST_CONTINUE = '-';

    FindObjectFilterSerializer.LIST_END = '_';

    FindObjectFilterSerializer.ESCAPE = '.';

    FindObjectFilterSerializer.AbbreviatedOperator = {
      and: "an",
      between: "bt",
      contains: "ct",
      equals: "eq",
      greaterOrEqual: "ge",
      greaterThan: "gt",
      "in": "in",
      isNotNull: "nN",
      isNull: "iN",
      lessOrEqual: "le",
      lessThan: "lt",
      like: "lk",
      not: "nt",
      notEqual: "ne",
      notLike: "nl",
      or: "or",
      ENCODED_LENGTH: 2
    };

    FindObjectFilterSerializer.Intrinsic = {
      abortedBy: "_aB",
      abortStatus: "_aS",
      createTime: "_cT",
      credentialName: "_cN",
      directoryName: "_dN",
      elapsedTime: "_eT",
      errorCode: "_eC",
      errorMessage: "_eM",
      finish: "_fn",
      jobId: "_jI",
      jobName: "_jN",
      lastModifiedBy: "_lM",
      launchedByUser: "_lB",
      licenseWaitTime: "_lW",
      liveProcedure: "_lP",
      liveSchedule: "_lS",
      modifyTime: "_mT",
      outcome: "_oc",
      owner: "_ow",
      priority: "_pr",
      procedureName: "_pc",
      projectName: "_pj",
      resourceWaitTime: "_rW",
      runAsUser: "_rU",
      scheduleName: "_sc",
      start: "_sr",
      stateName: "_sN",
      status: "_st",
      totalWaitTime: "_tW",
      workspaceWaitTime: "_wW"
    };

    FindObjectFilterSerializer.encodeOperator = function(operator) {
      return this.AbbreviatedOperator[operator];
    };

    FindObjectFilterSerializer.encodePropertyName = function(propertyName) {
      return this.Intrinsic[propertyName];
    };

    FindObjectFilterSerializer.decodeOperator = function(operator) {
      var key, value, _ref;
      _ref = this.AbbreviatedOperator;
      for (key in _ref) {
        value = _ref[key];
        if (value === operator) {
          return key;
        }
      }
      return null;
    };

    FindObjectFilterSerializer.decodePropertyName = function(propertyName) {
      var key, value, _ref;
      _ref = this.Intrinsic;
      for (key in _ref) {
        value = _ref[key];
        if (value === propertyName) {
          return key;
        }
      }
      return null;
    };

    FindObjectFilterSerializer.serializeString = function(sb, s) {
      var c, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = s.length; _i < _len; _i++) {
        c = s[_i];
        switch (c) {
          case this.FILTER_SEPARATOR:
          case this.ARGUMENT_SEPARATOR:
          case this.LIST_BEGIN:
          case this.ESCAPE:
            sb.push(this.ESCAPE);
            sb.push(c);
            break;
          default:
            sb.push(c);
            break;
        }
      }
      return _results;
    };

    FindObjectFilterSerializer.deserializeString = function(s) {
      var begin, c, sb;
      sb = new Array();
      begin = s.idx;
      while (s.idx < s.str.length) {
        c = s.str.charAt(s.idx);
        switch (c) {
          case this.ARGUMENT_SEPARATOR:
          case this.LIST_CONTINUE:
          case this.LIST_END:
            return sb.join('');
          case this.ESCAPE:
            if (s.idx === s.str.length - 1) {
              console.log('Malformed escape at ' + s.str.substring(begin));
            }
            c = s.str.charAt(++s.idx);
            sb.push(c);
            ++s.idx;
            break;
          default:
            sb.push(c);
            ++s.idx;
            break;
        }
      }
      return sb.join('');
    };

    FindObjectFilterSerializer.serialize = function(filters) {
      var f, sb, _i, _len;
      sb = new Array();
      for (_i = 0, _len = filters.length; _i < _len; _i++) {
        f = filters[_i];
        if (sb.length > 0) {
          sb.push(this.FILTER_SEPARATOR);
        }
        this.serialize2(sb, f);
      }
      return sb.join('');
    };

    FindObjectFilterSerializer.serialize2 = function(sb, f) {
      var filters, first, i_encoded, object, op, propertyName, _i, _len;
      if (!(f instanceof FindObjectFilter)) {
        this.serializeString(sb, f);
        return null;
      }
      op = f.getParameter('operator');
      sb.push(this.encodeOperator(op));
      switch (op) {
        case 'and':
        case 'or':
        case 'not':
          sb.push(this.LIST_BEGIN);
          filters = f.getMultiValuedParameter('filter');
          if (filters == null) {
            sb.push(this.LIST_END);
            break;
          }
          first = true;
          for (_i = 0, _len = filters.length; _i < _len; _i++) {
            object = filters[_i];
            if (!(object instanceof FindObjectFilter)) {
              console.log('unexpected object type');
            }
            if (!first) {
              sb.push(this.LIST_CONTINUE);
            }
            this.serialize2(sb, object);
            first = false;
          }
          return sb.push(this.LIST_END);
        default:
          sb.push(this.ARGUMENT_SEPARATOR);
          propertyName = f.getStringParameter('propertyName');
          i_encoded = this.encodePropertyName(propertyName);
          if (i_encoded != null) {
            this.serializeString(sb, i_encoded);
          } else {
            this.serializeString(sb, propertyName);
          }
          if (op === 'isNull' || op === 'isNotNull') {
            break;
          }
          sb.push(this.ARGUMENT_SEPARATOR);
          this.serialize2(sb, f.getParameter('operand1'));
          if (op !== 'between') {
            break;
          }
          sb.push(this.ARGUMENT_SEPARATOR);
          this.serialize2(sb, f.getParameter('operand2'));
          break;
      }
    };

    FindObjectFilterSerializer.deserialize = function(serialized, filters) {
      var s;
      s = new ParsedString(serialized);
      while (s.idx < serialized.length) {
        if (s.idx > 0) {
          s.check(this.FILTER_SEPARATOR, 'Malformed filter list');
        }
        filters.push(this.deserialize2(s));
      }
      return filters;
    };

    FindObjectFilterSerializer.deserialize2 = function(s) {
      var arg, child, f, first, intrinsic, o, op;
      if (s.str.charAt(s.idx) === this.LIST_END) {
        return null;
      }
      if (s.str.length < (s.idx + this.AbbreviatedOperator.ENCODED_LENGTH + 1)) {
        console.log('Malformed filter at ' + s.str.substring(s.idx));
      }
      op = s.str.substring(s.idx, s.idx + this.AbbreviatedOperator.ENCODED_LENGTH);
      s.idx += this.AbbreviatedOperator.ENCODED_LENGTH;
      o = this.decodeOperator(op);
      if (o == null) {
        console.log('Couldn\'t locate operator "' + op + '"');
      }
      f = new FindObjectFilter();
      f.setOperator(o);
      switch (o) {
        case 'and':
        case 'or':
        case 'not':
          first = true;
          s.check(this.LIST_BEGIN, 'Malformed "' + o + '" filter list');
          while (true) {
            if (!first) {
              ++s.idx;
            }
            child = this.deserialize2(s);
            if (child != null) {
              f.addFilter(child);
            }
            first = false;
            if (s.str.charAt(s.idx) !== this.LIST_CONTINUE) {
              break;
            }
          }
          s.check(this.LIST_END, 'Malformed "' + o + '" filter termination');
          break;
        default:
          s.check(this.ARGUMENT_SEPARATOR, 'Malformed "' + o + '" parameterName');
          arg = this.deserializeString(s);
          intrinsic = this.decodePropertyName(arg);
          if (intrinsic != null) {
            f.setPropertyName(intrinsic);
          } else {
            f.setPropertyName(arg);
          }
          if (o === 'isNull' || o === 'isNotNull') {
            break;
          }
          s.check(this.ARGUMENT_SEPARATOR, 'Malformed "' + o + '" operand1');
          arg = this.deserializeString(s);
          f.setOperand1(arg);
          if (o !== 'between') {
            break;
          }
          s.check(this.ARGUMENT_SEPARATOR, 'Malformed "' + o + '" operand2');
          arg = this.deserializeString(s);
          f.setOperand2(arg);
          break;
      }
      return f;
    };

    return FindObjectFilterSerializer;

  })();
});

/*
//@ sourceMappingURL=FindObjectsFilterSerializer.map
*/
