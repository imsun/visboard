var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Scatterplot, root;
  Scatterplot = (function(_super) {
    __extends(Scatterplot, _super);

    Scatterplot.counter = 0;

    function Scatterplot(name) {
      var self;
      Scatterplot.__super__.constructor.call(this);
      self = this;
      this.xAxis = new Axis('x axis');
      this.yAxis = new Axis('y axis');
      this.point = new Circle('point');
      this.yAxis.prop.rotate.value = 90;
      this.yAxis.prop.y.value = 100;
      this.yAxis.prop.range.value = [10, 0];
      _.extend(this.prop, {
        pointData: {
          name: 'Point',
          type: 'select',
          value: null,
          set: function() {
            var key, result, value, _ref;
            result = [
              {
                name: 'none',
                value: null
              }
            ];
            _ref = Data.get().members;
            for (key in _ref) {
              value = _ref[key];
              if (!value.hidden) {
                result.push({
                  name: key,
                  value: key
                });
              }
            }
            return result;
          },
          listener: function(value) {
            Data.get().members[value].output();
            self.prop.pointData.value = value;
            self.point.bind(value);
            return Renderer.renderAll();
          }
        },
        xAxis: {
          name: 'X axis',
          type: 'select',
          value: null,
          set: function() {
            var data, dataName, key, result, value, _ref;
            result = [
              {
                name: 'none',
                value: null
              }
            ];
            _ref = Data.get().members;
            for (dataName in _ref) {
              value = _ref[dataName];
              if (!value.hidden) {
                data = value.data;
                if (_.isType(data[0], 'Array')) {
                  data = data[0];
                }
                for (key in data[0]) {
                  result.push({
                    name: "" + dataName + "." + key,
                    value: JSON.stringify([dataName, key])
                  });
                }
              }
            }
            return result;
          },
          listener: function(value) {
            self.setXAxis(value);
            return Renderer.renderAll();
          }
        },
        yAxis: {
          name: 'Y axis',
          type: 'select',
          value: null,
          set: function() {
            var data, dataName, key, result, value, _ref;
            result = [
              {
                name: 'none',
                value: null
              }
            ];
            _ref = Data.get().members;
            for (dataName in _ref) {
              value = _ref[dataName];
              if (!value.hidden) {
                data = value.data;
                if (_.isType(data[0], 'Array')) {
                  data = data[0];
                }
                for (key in data[0]) {
                  result.push({
                    name: "" + dataName + "." + key,
                    value: JSON.stringify([dataName, key])
                  });
                }
              }
            }
            return result;
          },
          listener: function(value) {
            self.setYAxis(value);
            return Renderer.renderAll();
          }
        },
        width: {
          name: 'Width',
          type: 'number',
          value: 300,
          listener: function(value) {
            self.setWidth(value);
            return Renderer.renderAll();
          }
        },
        height: {
          name: 'Height',
          type: 'number',
          value: 150,
          listener: function(value) {
            self.setHeight(value);
            return Renderer.renderAll();
          }
        }
      });
      this.setCode(['pointData', 'xAxis', 'yAxis']);
      this.updateChildren();
      Primitives.tree.changeParent(this.xAxis, this.id);
      Primitives.tree.changeParent(this.yAxis, this.id);
      Primitives.tree.changeParent(this.point, this.id);
      TreePanel.select(this.treeNode);
    }

    Scatterplot.prototype.init = function(name) {
      this.type = 'scatterplot';
      return this.name = name || 'Scatterplot ' + Scatterplot.counter++;
    };

    Scatterplot.prototype.setWidth = function(value) {
      this.prop.width.value = value;
      this.xAxis.prop.length.value = value;
      return this.setXAxis(this.prop.xAxis.value);
    };

    Scatterplot.prototype.setHeight = function(value) {
      this.prop.height.value = value;
      this.yAxis.prop.length.value = value;
      this.yAxis.prop.y.value = value;
      return this.setYAxis(this.prop.yAxis.value);
    };

    Scatterplot.prototype.setXAxis = function(value) {
      var step, xColumn, xDomain, xMax, xMin;
      if (value === 'null') {
        value = null;
      }
      this.prop.xAxis.value = value;
      if (value) {
        xDomain = value;
        if (_.isType(xDomain, 'String')) {
          xDomain = JSON.parse(xDomain);
        }
        xColumn = Data.get().list[xDomain[0]].map(function(row) {
          var e;
          try {
            return parseFloat(row[xDomain[1]]);
          } catch (_error) {
            e = _error;
            return 0;
          }
        });
        xMax = Math.max.apply(this, xColumn);
        xMin = Math.min.apply(this, xColumn);
        if (xMin >= 0) {
          this.xAxis.prop.range.value = [0, xMax];
          if (this.prop.pointData.value) {
            this.point.prop.x.value = "$data['" + xDomain[1] + "'] / " + xMax + " * " + this.prop.width.value;
          }
          return this.yAxis.prop.x.value = 0;
        } else {
          this.xAxis.prop.range.value = [xMin, xMax];
          step = this.prop.width.value / (xMax - xMin);
          if (this.prop.pointData.value) {
            this.point.prop.x.value = "$data['" + xDomain[1] + "'] * " + step + " + " + (-xMin * step);
          }
          return this.yAxis.prop.x.value = "" + (-xMin * step);
        }
      } else {
        this.xAxis.prop.range.value = [0, 10];
        this.point.prop.x.value = 0;
        return this.yAxis.prop.x.value = 0;
      }
    };

    Scatterplot.prototype.setYAxis = function(value) {
      var step, yColumn, yDomain, yMax, yMin;
      if (value === 'null') {
        value = null;
      }
      this.prop.yAxis.value = value;
      if (value) {
        yDomain = value;
        if (_.isType(yDomain, 'String')) {
          yDomain = JSON.parse(yDomain);
        }
        yColumn = Data.get().list[yDomain[0]].map(function(row) {
          var e;
          try {
            return parseFloat(row[yDomain[1]]);
          } catch (_error) {
            e = _error;
            return 0;
          }
        });
        yMax = Math.max.apply(this, yColumn);
        yMin = Math.min.apply(this, yColumn);
        if (yMin >= 0) {
          this.yAxis.prop.range.value = [yMax, 0];
          if (this.prop.pointData.value) {
            this.point.prop.y.value = "$data['" + yDomain[1] + "'] / " + yMax + " * " + this.prop.height.value;
          }
          return this.xAxis.prop.y.value = 0;
        } else {
          this.yAxis.prop.range.value = [yMax, yMin];
          step = this.prop.height.value / (yMax - yMin);
          if (this.prop.pointData.value) {
            this.point.prop.y.value = "$data['" + yDomain[1] + "'] * " + step + " + " + (-yMin * step);
          }
          return this.xAxis.prop.y.value = "" + (-yMin * step);
        }
      } else {
        this.yAxis.prop.range.value = [10, 0];
        this.point.prop.y.value = 0;
        return this.xAxis.prop.y.value = 0;
      }
    };

    Scatterplot.prototype.updateChildren = function() {
      this.setWidth(this.prop.width.value);
      this.setHeight(this.prop.height.value);
      this.setXAxis(this.prop.xAxis.value);
      this.setYAxis(this.prop.yAxis.value);
      return Renderer.renderAll();
    };

    return Scatterplot;

  })(Primitive);
  if (typeof exports !== "undefined" && exports !== null) {
    root = exports;
  } else {
    root = this;
  }
  return _.extend(root, {
    Scatterplot: Scatterplot
  });
})();
