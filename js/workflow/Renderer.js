(function() {
  var Renderer;
  Renderer = {
    primitives: {
      root: {
        type: 'root',
        children: []
      }
    },
    target: '#viewport',
    renderAll: function() {
      Renderer.clear();
      return Renderer.render(Primitives.tree.data);
    },
    render: function(list) {
      Renderer.primitives = {
        root: {
          type: 'root',
          children: []
        }
      };
      Renderer._render('root', 'root', list, {
        $data: null,
        $index: null,
        $parent: null
      });
      Renderer.draw(Renderer.primitives);
      return Renderer.primitives;
    },
    _render: function(id, pid, list, $parent) {
      var child, children, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = list[pid].children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        children = Renderer["eval"](child, list[child].target, $parent);
        Renderer.primitives[id].children = Renderer.primitives[id].children.concat(children);
      }
      _ref1 = Renderer.primitives[id].children;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        child = _ref1[_j];
        _results.push(Renderer._render(child.id, child.pid, list, child.dataRefer));
      }
      return _results;
    },
    clear: function() {
      if ($('#viewport')) {
        return $('#viewport').innerHTML = '';
      }
    },
    "eval": function(pid, primitive, $parent) {
      var $domain, data, dataName, evalProp, item, items, prop, runner, _domain;
      prop = primitive.prop;
      if (pid === 'root') {
        return;
      }
      evalProp = function(value, $data, $index, $domain, $parent) {
        var propValue, _runner;
        if (value.enableCode) {
          propValue = value.code;
        } else {
          propValue = value.value;
        }
        _runner = function(value, enableCode) {
          var $Max, $Min, e, fn;
          $Max = function(list) {
            return Math.max.apply(this, list);
          };
          $Min = function(list) {
            return Math.min.apply(this, list);
          };
          if (_.isType(value, 'String')) {
            if (!enableCode) {
              try {
                value = eval(value);
              } catch (_error) {
                e = _error;
              }
            } else {
              try {
                fn = eval("(" + value + ")");
                value = fn($data, $index, $domain, $parent);
              } catch (_error) {
                e = _error;
                console.log(e);
              }
            }
          }
          return value;
        };
        if (_.isType(propValue, 'Array')) {
          return propValue.map(function(_value) {
            return _runner(_value, value.enableCode);
          });
        } else {
          return _runner(propValue, value.enableCode);
        }
      };
      runner = function($data, $index, $domain, $parent) {
        var _primitive;
        _primitive = {
          id: _.cid(),
          pid: pid,
          type: primitive.type,
          children: [],
          dataRefer: {
            $data: $data,
            $index: $index,
            $parent: $parent
          },
          prop: (function() {
            var key, value, _prop;
            _prop = {};
            for (key in prop) {
              value = prop[key];
              _prop[key] = {};
              _.extend(_prop[key], value);
              _prop[key].value = evalProp(value, $data, $index, $domain, $parent);
            }
            return _prop;
          })()
        };
        Renderer.primitives[_primitive.id] = _primitive;
        return _primitive;
      };
      Data.workflow(primitive.id).checkInput();
      dataName = evalProp(prop.data, null, null, null, $parent);
      data = Data.get(primitive.id).list[dataName];
      if (data && _.isType(data[0], 'Array')) {
        data = Data.get(primitive.id).list[dataName + '.' + $parent.$index];
      }
      if (data) {
        items = data.map(function(row, index) {
          var $domain, _domain;
          $domain = null;
          if ((prop.domain != null) && ((prop.domain.value != null) || prop.domain.enableCode)) {
            if (_.isType(prop.domain.value, 'String')) {
              prop.domain.value = JSON.parse(prop.domain.value);
            }
            _domain = evalProp(prop.domain, row, index, null, $parent);
            $domain = Data.get(primitive.id).list[_domain[0]].map(function(row) {
              return row[_domain[1]];
            });
          }
          return runner(row, index, $domain, $parent);
        });
        return items;
      } else {
        $domain = null;
        if ((prop.domain != null) && ((prop.domain.value != null) || prop.domain.enableCode)) {
          if (_.isType(prop.domain.value, 'String')) {
            prop.domain.value = JSON.parse(prop.domain.value);
          }
          _domain = evalProp(prop.domain, null, null, null, $parent);
          $domain = Data.get(primitive.id).list[_domain[0]].map(function(row) {
            return row[_domain[1]];
          });
        }
        item = runner(null, null, $domain, $parent);
        return [item];
      }
    },
    draw: function(primitives) {
      var height, svg, width;
      primitives = primitives || Renderer.primitives;
      width = $(Renderer.target).width;
      height = $(Renderer.target).height;
      svg = d3.select(Renderer.target).append('svg').attr('width', width).attr('height', height);
      return Renderer._draw(primitives.root, svg);
    },
    _draw: function(primitive, parent) {
      var axis, child, display, el, height, prop, scale, width, x, y, _i, _len, _ref;
      el = null;
      prop = primitive.prop;
      width = $(Renderer.target).width;
      height = $(Renderer.target).height;
      display = 'inline';
      if ((prop != null) && !prop.visiable.value) {
        display = 'none';
      }
      if ((prop != null) && (prop.x != null) && (prop.y != null)) {
        x = parseFloat(prop.x.value);
        y = -parseFloat(prop.y.value);
      }
      switch (primitive.type) {
        case 'root':
          el = parent.append('g').attr('transform', "translate(40, " + (height / 2) + ")");
          break;
        case 'circle':
          el = parent.append('circle').attr('cx', x).attr('cy', y).attr('r', prop.radius.value).style('fill', 'black');
          break;
        case 'axis':
          scale = d3.scale.linear().domain(prop.range.value).range([0, prop.length.value]);
          axis = d3.svg.axis().scale(scale).ticks(prop.ticks.value).orient('bottom');
          el = parent.append('g').attr('class', 'axis').attr('transform', "translate(" + x + ", " + y + ") rotate(" + prop.rotate.value + ")").call(axis);
          break;
        default:
          el = parent.append('g').attr('transform', "translate(" + x + ", " + y + ") rotate(" + prop.rotate.value + ") scale(" + prop.scale.value + ")");
      }
      el.attr('style', "display: " + display);
      _ref = primitive.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        Renderer._draw(child, el);
      }
      return el;
    }
  };
  if (typeof exports !== "undefined" && exports !== null) {
    return module.exports = Renderer;
  } else {
    return this.Renderer = Renderer;
  }
})();
