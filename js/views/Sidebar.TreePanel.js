var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Node, Tree, TreePanel;
  TreePanel = (function(_super) {
    __extends(TreePanel, _super);

    function TreePanel() {
      return TreePanel.__super__.constructor.apply(this, arguments);
    }

    TreePanel.prototype.selectListener = [];

    TreePanel.prototype.init = function(id, data) {
      this.id = id;
      this.domElement = document.createElement('div');
      this.domElement.id = id;
      this.domElement.className = 'tree-panel';
      return this.tree = new Tree(this, _.cid(), data, ['root'], this);
    };

    TreePanel.prototype.select = function(node) {
      var listener, _i, _len, _ref;
      if (!node) {
        return;
      }
      if (this.selected != null) {
        this.selected.domElement.titleEl.className = 'tree-node-title';
      }
      node.domElement.titleEl.className = 'tree-node-title selected';
      this.selected = node;
      Data.workflow(node.target.id).checkInput();
      _ref = this.selectListener;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        listener.fn.call(listener.self, node);
      }
      if (typeof DataPool !== "undefined" && DataPool !== null) {
        DataPool.display(_.copy(Data.get().tree));
      }
      if (typeof DataPanel !== "undefined" && DataPanel !== null) {
        return DataPanel.clear();
      }
    };

    TreePanel.prototype.update = function(data) {
      return this.tree.update(data);
    };

    return TreePanel;

  })(View);
  Tree = (function(_super) {
    __extends(Tree, _super);

    function Tree() {
      return Tree.__super__.constructor.apply(this, arguments);
    }

    Tree.prototype.init = function(id, data, keys, root) {
      this.id = id;
      this.data = data;
      this.root = root;
      this.keys = keys;
      this.domElement = document.createElement('ul');
      this.domElement.id = id;
      this.domElement.className = 'tree';
      return this._genTree(this, keys);
    };

    Tree.prototype._genTree = function(parent, keys) {
      var key, node, _i, _len, _results;
      if ((keys == null) || (this.data == null)) {
        return;
      }
      _results = [];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        _results.push(node = new Node(parent, _.cid(), this.data, this.data[key], this.root));
      }
      return _results;
    };

    Tree.prototype.update = function(data) {
      this.data = data || this.data;
      this.clear();
      return this._genTree(this, this.keys);
    };

    return Tree;

  })(View);
  Node = (function(_super) {
    __extends(Node, _super);

    function Node() {
      return Node.__super__.constructor.apply(this, arguments);
    }

    Node.prototype.init = function(id, data, el, root) {
      var self, title;
      this.id = id;
      this.data = data;
      this.target = el.target;
      this.name = el.name;
      this.root = root;
      self = this;
      el.target.treeNode = this;
      title = document.createElement('span');
      title.className = 'tree-node-title';
      title.innerHTML = this.name;
      title.addEventListener('click', function(e) {
        return self.root.select(self);
      });
      this.domElement = document.createElement('li');
      this.domElement.id = id;
      this.domElement.className = 'tree-node';
      this.domElement.titleEl = title;
      this.domElement.appendChild(title);
      this.domElement.subTree = new Tree(this, _.cid(), this.data, null, this.root);
      if ((el.children != null) && el.children.length > 0) {
        return this.parent._genTree(this.domElement.subTree, el.children);
      }
    };

    Node.prototype.changeParent = function(newParent) {
      this.parent.domElement.removeChild(this.domElement);
      this.parent = newParent;
      return newParent.add(this);
    };

    return Node;

  })(View);
  return this.Sidebar.TreePanel = TreePanel;
})();
