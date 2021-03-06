var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Axis, Circle, Group, Primitive, Primitives, Root, root;
  Primitives = {
    list: [],
    tree: {
      data: {},
      insert: function(primitive) {
        var dataList;
        dataList = Primitives.tree.data;
        _.extend(primitive, {
          target: primitive,
          children: []
        });
        dataList[primitive.id] = primitive;
        Primitives.list[primitive.id] = {
          type: primitive.type,
          prop: primitive.prop
        };
        if ((primitive.parent != null) && (dataList[primitive.parent] != null)) {
          dataList[primitive.parent].children.push(primitive.id);
        }
        if (typeof TreePanel !== "undefined" && TreePanel !== null) {
          TreePanel.update();
          return TreePanel.select(primitive.treeNode);
        }
      },
      changeParent: function(primitive, parent) {
        var children, dataList, index;
        dataList = Primitives.tree.data;
        children = dataList[primitive.parent].children;
        index = children.indexOf(primitive.id);
        children.splice(index, 1);
        primitive.parent = parent;
        primitive.prop.parent.value = parent;
        dataList[parent].children.push(primitive.id);
        primitive.treeNode.changeParent(dataList[parent].target.treeNode.domElement.subTree);
        TreePanel.update(dataList);
        return TreePanel.select(primitive.treeNode);
      }
    }
  };
  Primitive = (function() {
    Primitive.counter = 0;

    function Primitive(name) {
      var self;
      self = this;
      this.parent = 'root';
      this.id = 'UID' + Primitive.counter++;
      Data.add(this.id);
      this.type = 'primitive';
      this.name = name || 'Primitive';
      this.data = null;
      this.prop = {
        name: {
          name: 'Name',
          type: 'text',
          value: function() {
            return self.name;
          },
          listener: function(value) {
            self.name = value;
            self.prop.name.value = value;
            return TreePanel.update(Primitives.tree.data);
          }
        },
        parent: {
          name: 'Parent',
          type: 'select',
          value: this.parent,
          set: function() {
            var key, result, value, _ref, _ref1;
            result = [];
            _ref = Primitives.tree.data;
            for (key in _ref) {
              value = _ref[key];
              if (key !== self.id && ((_ref1 = value.target.type) === 'root' || _ref1 === 'scatterplot' || _ref1 === 'group')) {
                result.push({
                  name: value.name,
                  value: key
                });
              }
            }
            return result;
          },
          listener: function(value) {
            Primitives.tree.changeParent(self, value);
            return Renderer.renderAll();
          }
        },
        data: {
          name: 'Data',
          type: 'select',
          value: this.data,
          set: function() {
            var key, result, value, _ref;
            result = [
              {
                name: 'none',
                value: null
              }
            ];
            _ref = Data.get(self.id).members;
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
            self.bind(value);
            return Renderer.renderAll();
          }
        },
        visiable: {
          name: 'Visiable',
          type: 'boolean',
          value: true,
          listener: function(value) {
            self.prop.visiable.value = value;
            return Renderer.renderAll();
          }
        },
        x: {
          name: 'X',
          type: 'number',
          value: 0,
          listener: function(value) {
            self.setX(value);
            return Renderer.renderAll();
          }
        },
        y: {
          name: 'Y',
          type: 'number',
          value: 0,
          listener: function(value) {
            self.setY(value);
            return Renderer.renderAll();
          }
        },
        scale: {
          name: 'Scale',
          type: 'number',
          value: 1.0,
          listener: function(value) {
            self.setScale(value);
            return Renderer.renderAll();
          }
        },
        rotate: {
          name: 'Rotate',
          type: 'number',
          value: 0,
          listener: function(value) {
            self.setRotate(value);
            return Renderer.renderAll();
          }
        }
      };
      this.init(name);
      this.setCode();
      Primitives.tree.insert(this);
      if (this.parent && this.parent !== 'root') {
        Primitives.tree.changeParent(this, this.parent);
      }
    }

    Primitive.prototype.init = function() {};

    Primitive.prototype.bind = function(data) {
      if (data === 'null') {
        return this.data = this.prop.data.value = null;
      } else {
        return this.data = this.prop.data.value = data;
      }
    };

    Primitive.prototype.setX = function(value) {
      return this.prop.x.value = value;
    };

    Primitive.prototype.setY = function(value) {
      return this.prop.y.value = value;
    };

    Primitive.prototype.setScale = function(value) {
      return this.prop.scale.value = value;
    };

    Primitive.prototype.setRotate = function(value) {
      return this.prop.rotate.value = value;
    };

    Primitive.prototype.setCode = function(disableList) {
      var key, propValue, value, _ref, _results;
      _ref = this.prop;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        if (!(key === 'id' || key === 'name' || key === 'parent') && ((disableList == null) || !(__indexOf.call(disableList, key) >= 0)) && value.type !== 'title' && (value.code == null)) {
          propValue = value.value;
          if (_.isType(value.value, 'Function')) {
            propValue = value.value();
          }
          if ((_.isType(propValue, 'Object')) || (_.isType(propValue, 'Array'))) {
            propValue = JSON.stringify(propValue);
          } else if (_.isType(propValue, 'String')) {
            propValue = "'" + propValue + "'";
          }
          value.code = "function($data, $index, $domain, $parent) {\n    return " + propValue + "\n}";
          _results.push(value.enableCode = false);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return Primitive;

  })();
  Root = (function(_super) {
    __extends(Root, _super);

    function Root() {
      return Root.__super__.constructor.apply(this, arguments);
    }

    Root.prototype.init = function() {
      delete this.parent;
      delete this.data;
      delete this.prop.parent;
      delete this.prop.data;
      Data.remove(this.id);
      this.id = 'root';
      Data.add(this.id);
      this.type = 'root';
      return this.name = 'Root';
    };

    return Root;

  })(Primitive);
  Circle = (function(_super) {
    __extends(Circle, _super);

    function Circle() {
      return Circle.__super__.constructor.apply(this, arguments);
    }

    Circle.counter = 0;

    Circle.prototype.init = function(name) {
      var self;
      self = this;
      this.type = 'circle';
      this.name = name || 'Circle ' + Circle.counter++;
      return _.extend(this.prop, {
        radius: {
          name: 'Radius',
          type: 'number',
          value: 5,
          listener: function(value) {
            self.prop.radius.value = value;
            return Renderer.renderAll();
          }
        }
      });
    };

    return Circle;

  })(Primitive);
  Group = (function(_super) {
    __extends(Group, _super);

    function Group() {
      return Group.__super__.constructor.apply(this, arguments);
    }

    Group.counter = 0;

    Group.prototype.init = function(name) {
      this.type = 'group';
      return this.name = name || 'Group ' + Group.counter++;
    };

    return Group;

  })(Primitive);
  Axis = (function(_super) {
    __extends(Axis, _super);

    function Axis() {
      return Axis.__super__.constructor.apply(this, arguments);
    }

    Axis.counter = 0;

    Axis.prototype.init = function(name) {
      var self;
      self = this;
      this.type = 'axis';
      this.name = name || 'Axis ' + Axis.counter++;
      return _.extend(this.prop, {
        length: {
          name: 'Length',
          type: 'number',
          value: 100,
          listener: function(value) {
            self.prop.length.value = value;
            return Renderer.renderAll();
          }
        },
        ticks: {
          name: 'Ticks',
          type: 'number',
          value: 10,
          listener: function(value) {
            self.prop.ticks.value = value;
            return Renderer.renderAll();
          }
        },
        range: {
          name: 'Range',
          type: 'range',
          value: [0, 10],
          listener: function(value) {
            self.prop.range.value = value;
            return Renderer.renderAll();
          }
        }
      });
    };

    return Axis;

  })(Primitive);
  new Root();
  if (typeof exports !== "undefined" && exports !== null) {
    root = exports;
  } else {
    root = this;
  }
  return _.extend(root, {
    Primitives: Primitives,
    Primitive: Primitive,
    Axis: Axis,
    Circle: Circle,
    Group: Group
  });
})();
