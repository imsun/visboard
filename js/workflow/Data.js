var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Data, Workflow;
  Workflow = function(owner) {
    var Cluster, DataModel, Filter, Scale, Tool, outPool, wf;
    this.owner = owner;
    owner = this.owner;
    wf = this;
    this.outPool = outPool = {};
    this.checkInput = function() {
      var inPool, key, parent, value, _results;
      if (Primitives.list[owner].prop.parent != null) {
        parent = Primitives.list[owner].prop.parent.value;
        inPool = Data.workflow(parent).outPool;
        _results = [];
        for (key in inPool) {
          value = inPool[key];
          if (!DataModel.list[key]) {
            _results.push(new wf.DataModel(key, value.data));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };
    this.DataModel = DataModel = (function() {
      _Class.list = {};

      _Class.tree = [];

      _Class.members = {};

      _Class.getNode = function(name, trees) {
        var result, tree, _i, _j, _len, _len1;
        for (_i = 0, _len = trees.length; _i < _len; _i++) {
          tree = trees[_i];
          if (tree.name === name) {
            return tree;
          }
        }
        for (_j = 0, _len1 = trees.length; _j < _len1; _j++) {
          tree = trees[_j];
          result = this.getNode(name, tree.children);
          if (result) {
            return result;
          }
        }
      };

      _Class.prototype.output = function() {
        return outPool[this.name] = this;
      };

      function _Class(name, data, parent, hidden) {
        var dataArrayFlag, dataNode, keys, node, self;
        this.name = name;
        this.data = data;
        this.hidden = hidden;
        self = this;
        name = this.name;
        dataArrayFlag = false;
        if (_.isType(this.data[0], 'Array')) {
          dataArrayFlag = true;
          keys = Object.keys(data[0][0]);
        } else {
          keys = Object.keys(data[0]);
        }
        DataModel.list[name] = this.data;
        DataModel.members[name] = this;
        dataNode = {
          name: name,
          type: 'data',
          parent: parent,
          children: [],
          hidden: hidden,
          prop: {
            title: {
              name: (function() {
                if (dataArrayFlag) {
                  return 'Data Set';
                }
                return 'Data';
              })(),
              type: 'title'
            },
            name: {
              name: 'Name',
              type: 'label',
              value: name
            },
            rows: {
              name: 'Rows',
              type: 'label',
              value: (function() {
                return self.data.length;
              })()
            },
            preview: {
              name: 'Preview',
              type: 'html',
              value: (function() {
                var table, th, tr;
                data = DataModel.list[name];
                tr = '';
                th = '<thead><tr><th>' + (keys.join('</th><th>')) + '</th></tr></thead>';
                if (!dataArrayFlag) {
                  data.forEach(function(row, i) {
                    var td;
                    td = '';
                    keys.forEach(function(key, j) {
                      return td += "<td>" + row[key] + "</td>";
                    });
                    return tr += "<tr>" + td + "</tr>";
                  });
                }
                table = "<table>" + th + "<tbody>" + tr + "</tbody></table>";
                return table;
              })()
            }
          }
        };
        if (dataArrayFlag) {
          this.data.forEach(function(data, index) {
            return new wf.DataModel(name + '.' + index, data, parent, true);
          });
        }
        if (!hidden) {
          if (parent != null) {
            node = DataModel.getNode(parent, DataModel.tree);
            node.children.push(dataNode);
          } else {
            DataModel.tree.push(dataNode);
          }
          if (typeof DataPool !== "undefined" && DataPool !== null) {
            DataPool.display(_.copy(DataModel.tree));
          }
          if (typeof DataPanel !== "undefined" && DataPanel !== null) {
            DataPanel.display(dataNode);
          }
        }
        return this;
      }

      return _Class;

    })();
    this.Tool = Tool = (function() {
      function _Class() {
        var dataNode, name, self;
        self = this;
        name = 'Tool ' + Tool.counter++;
        this.name = name;
        dataNode = {
          id: _.cid(),
          name: name,
          type: 'tool',
          parent: null,
          children: [],
          prop: {
            title: {
              name: 'Tool',
              type: 'title'
            },
            name: {
              name: 'Name',
              type: 'text',
              value: name,
              listener: function(value) {
                self.dataNode.name = value;
                self.dataNode.prop.name.value = value;
                return self.update();
              }
            },
            input: {
              name: 'Input',
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
                _ref = DataModel.list;
                for (key in _ref) {
                  value = _ref[key];
                  result.push({
                    name: key,
                    value: key
                  });
                }
                return result;
              },
              listener: function(value) {
                return self.setInput(value);
              }
            }
          }
        };
        this.dataNode = dataNode;
        this.init();
        DataModel.tree.push(dataNode);
        if (typeof DataPool !== "undefined" && DataPool !== null) {
          DataPool.display(DataModel.tree);
        }
        if (typeof DataPanel !== "undefined" && DataPanel !== null) {
          DataPanel.display(dataNode);
        }
      }

      _Class.counter = 0;

      _Class.prototype.update = function() {
        var child, _i, _len, _ref;
        _ref = this.dataNode.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          delete Data.list[child.name];
        }
        return this.dataNode.children = [];
      };

      _Class.prototype.setInput = function(value) {
        var index, oldParent, parent;
        if (value === 'null') {
          value = null;
        }
        if (this.dataNode.parent != null) {
          oldParent = DataModel.getNode(this.dataNode.parent, Data.tree).children;
        } else {
          oldParent = DataModel.tree;
        }
        index = oldParent.indexOf(this.dataNode);
        oldParent.splice(index, 1);
        this.dataNode.parent = value;
        this.dataNode.prop.input.value = value;
        if (value != null) {
          parent = DataModel.getNode(value, DataModel.tree).children;
        } else {
          parent = DataModel.tree;
        }
        parent.push(this.dataNode);
        return this.update();
      };

      _Class.prototype.init = function() {};

      return _Class;

    })();
    this.Filter = Filter = (function(_super) {
      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.counter = 0;

      _Class.prototype.init = function() {
        var self;
        self = this;
        this.dataNode.name = this.dataNode.prop.name.value = this.name = 'filter ' + Filter.counter++;
        this.dataNode.prop.title.name = 'Filter';
        this.dataNode.type = 'filter';
        return _.extend(this.dataNode.prop, {
          select: {
            name: 'Select',
            type: 'text',
            value: null,
            listener: function(value) {
              if (value === 'null') {
                value = null;
              }
              self.dataNode.prop.select.value = value;
              return self.update();
            }
          },
          rules: {
            name: 'Rules',
            type: 'text',
            value: null,
            listener: function(value) {
              self.dataNode.prop.rules.value = value;
              return self.update();
            }
          }
        });
      };

      _Class.prototype.update = function() {
        var i, input, inputName, output, rules, select;
        _Class.__super__.update.call(this);
        inputName = this.dataNode.prop.input.value;
        select = this.dataNode.prop.select.value;
        rules = this.dataNode.prop.rules.value;
        if (!select || !inputName) {
          DataPool.display(DataModel.tree);
          return;
        }
        input = DataModel.list[inputName];
        if (select !== '*') {
          select = select.split(',').map(function(row) {
            return row.trim();
          });
        }
        output = [];
        input.forEach(function(row, index) {
          var fn, result;
          if (rules) {
            fn = eval("(function ($data, $index) { return " + rules + "})");
            if (!fn(row, index)) {
              return;
            }
          }
          if (select === '*') {
            return output.push(_.copy(row));
          } else {
            result = {};
            select.forEach(function(key) {
              return result[key] = _.copy(row[key]);
            });
            return output.push(result);
          }
        });
        i = 0;
        while (DataModel.list[inputName + '.' + i]) {
          i++;
        }
        return new DataModel(inputName + '.' + i, output, this.dataNode.name);
      };

      return _Class;

    })(this.Tool);
    this.Cluster = Cluster = (function(_super) {
      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.counter = 0;

      _Class.prototype.init = function() {
        var self;
        self = this;
        this.dataNode.name = this.dataNode.prop.name.value = this.name = 'cluster ' + Cluster.counter++;
        this.dataNode.prop.title.name = 'Cluster';
        this.dataNode.type = 'cluster';
        return _.extend(this.dataNode.prop, {
          key: {
            name: 'Key',
            type: 'text',
            value: null,
            listener: function(value) {
              if (value === 'null') {
                value = null;
              }
              self.dataNode.prop.key.value = value;
              return self.update();
            }
          }
        });
      };

      _Class.prototype.update = function() {
        var genChildren, input, inputName, key, self;
        _Class.__super__.update.call(this);
        self = this;
        inputName = this.dataNode.prop.input.value;
        key = this.dataNode.prop.key.value;
        if (!key || !inputName) {
          DataPool.display(DataModel.tree);
          return;
        }
        genChildren = function(input) {
          var group, keys, list;
          group = {};
          list = [];
          input.forEach(function(row, index) {
            if (!group[row[key]]) {
              group[row[key]] = [];
            }
            return group[row[key]].push(_.copy(row));
          });
          keys = Object.keys(group).map(function(row) {
            var temp;
            list.push(group[row]);
            temp = {};
            temp[key] = row;
            return temp;
          });
          new DataModel(inputName + '.' + key, keys, self.dataNode.name);
          return new DataModel(inputName + '.' + key + '.set', list, self.dataNode.name);
        };
        input = DataModel.list[inputName];
        if (_.isType(input[0], 'Array')) {
          return input.forEach(function(data, index) {
            return genChildren(data);
          });
        } else {
          return genChildren(input);
        }
      };

      return _Class;

    })(this.Tool);
    this.Scale = Scale = (function(_super) {
      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.counter = 0;

      _Class.list = [];

      _Class.prototype.init = function() {
        var self;
        self = this;
        this.dataNode.name = this.dataNode.prop.name.value = this.name = 'scale' + Scale.counter++;
        this.dataNode.prop.title.name = 'Scale';
        this.dataNode.type = 'scale';
        this.dataNode.prop.input.listener;
        Scale.list.push(this.dataNode);
        return _.extend(this.dataNode.prop, {
          domain: {
            name: 'Domain',
            type: 'select',
            value: null,
            set: function() {
              var result;
              return result = [
                {
                  name: 'none',
                  value: null
                }
              ];
            },
            listener: function(value) {
              return self.dataNode.prop.domain.value = value;
            }
          },
          from: {
            name: 'From',
            type: 'range',
            value: ['$Min($domain)', '$Max($domain)'],
            listener: function(value) {
              return self.dataNode.prop.from.value = value;
            }
          },
          to: {
            name: 'To',
            type: 'range',
            value: [0, 100],
            listener: function(value) {
              return self.dataNode.prop.to.value = value;
            }
          }
        });
      };

      _Class.prototype.update = function() {
        _Class.__super__.update.call(this);
        if (typeof DataPool !== "undefined" && DataPool !== null) {
          return DataPool.display(_.copy(DataModel.tree));
        }
      };

      _Class.prototype.setInput = function(value) {
        if (value === 'null') {
          value = null;
        }
        _Class.__super__.setInput.call(this, value);
        this.dataNode.prop.domain.set = function() {
          var result;
          result = [
            {
              name: 'none',
              value: null
            }
          ];
          if (value != null) {
            Object.keys(DataModel.list[value][0]).forEach(function(key) {
              return result.push({
                name: key,
                value: key
              });
            });
          }
          return result;
        };
        if (typeof DataPanel !== "undefined" && DataPanel !== null) {
          return DataPanel.display(this.dataNode);
        }
      };

      return _Class;

    })(Tool);
    return this;
  };
  Data = {
    list: {},
    add: function(id) {
      return Data.list[id] = new Workflow(id);
    },
    workflow: function(id) {
      if (id != null) {
        return Data.list[id];
      }
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return Data.list[TreePanel.selected.target.id];
      }
      return null;
    },
    get: function(id) {
      if (id != null) {
        return Data.list[id].DataModel;
      }
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return Data.list[TreePanel.selected.target.id].DataModel;
      }
      return null;
    },
    tools: function(id) {
      if (id != null) {
        return Data.list[id];
      }
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return Data.list[TreePanel.selected.target.id];
      }
      return null;
    },
    outPool: function(id) {
      if (id != null) {
        return Data.list[id].outPool;
      }
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return Data.list[TreePanel.selected.target.id].outPool;
      }
      return null;
    },
    remove: function(id) {
      return delete Data.list[id];
    }
  };
  if (typeof exports !== "undefined" && exports !== null) {
    return module.exports = Data;
  } else {
    return this.Data = Data;
  }
})();
