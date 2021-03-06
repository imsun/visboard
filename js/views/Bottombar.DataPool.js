var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var DataPool;
  DataPool = (function(_super) {
    __extends(DataPool, _super);

    function DataPool() {
      return DataPool.__super__.constructor.apply(this, arguments);
    }

    DataPool.selected = null;

    DataPool.select = function(node) {
      return DataPool.selected = node;
    };

    DataPool.prototype.init = function(id) {
      this.id = id;
      this.domElement = document.createElement('div');
      this.domElement.id = this.id;
      return this.domElement.className = 'data-pool';
    };

    DataPool.prototype.display = function(dataTrees) {
      var Tree, dataTree, diagonal, fullHeight, group, height, i, link, links, node, nodes, style, svg, width, _i, _len, _results;
      this.clear();
      dataTrees = _.copy(dataTrees);
      style = getComputedStyle(this.domElement);
      width = parseFloat(style.getPropertyValue('width'));
      fullHeight = parseFloat(style.getPropertyValue('height'));
      height = fullHeight / dataTrees.length;
      Tree = d3.layout.tree().size([height, width - 200]).separation(function(a, b) {
        if (a.parent === b.parent) {
          return 1 / (a.depth + 1);
        } else {
          return 2 / (a.depth + 1);
        }
      });
      diagonal = d3.svg.diagonal().projection(function(d) {
        return [d.y, d.x];
      });
      svg = d3.select(this.domElement).append('svg').attr('width', width).attr('height', fullHeight);
      _results = [];
      for (i = _i = 0, _len = dataTrees.length; _i < _len; i = ++_i) {
        dataTree = dataTrees[i];
        nodes = Tree.nodes(dataTree);
        links = Tree.links(nodes);
        group = svg.append('g').attr('transform', "translate(40, " + (i * height) + ")");
        link = group.selectAll('.link').data(links).enter().append('path').attr('class', 'link').attr('d', diagonal);
        node = group.selectAll('.node').data(nodes).enter().append('g').attr('class', function(d, i) {
          return 'node ' + d.type;
        }).attr('transform', function(d) {
          return "translate(" + d.y + ", " + d.x + ")";
        }).on('click', function(d, i) {
          DataPool.select(this);
          if (typeof DataPanel !== "undefined" && DataPanel !== null) {
            return DataPanel.display(Data.get().getNode(d.name, Data.get().tree));
          }
        });
        node.append('circle').attr('r', 4.5);
        _results.push(node.append('text').attr('dx', function(d, i) {
          if (d.children && i) {
            return -8;
          } else {
            return 8;
          }
        }).attr('dy', 3).style('text-anchor', function(d, i) {
          if (d.children && i) {
            return 'end';
          } else {
            return 'start';
          }
        }).text(function(d) {
          return d.name;
        }));
      }
      return _results;
    };

    return DataPool;

  })(View);
  return this.Bottombar.DataPool = DataPool;
})();
