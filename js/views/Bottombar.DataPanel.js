var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var DataPanel;
  DataPanel = (function(_super) {
    __extends(DataPanel, _super);

    function DataPanel() {
      return DataPanel.__super__.constructor.apply(this, arguments);
    }

    DataPanel.prototype.init = function(id) {
      this.id = id;
      this.domElement = document.createElement('div');
      this.domElement.id = id;
      return this.domElement.className = 'data-panel';
    };

    DataPanel.prototype.display = function(node) {
      var addToPoolBtn, key, value, _ref;
      this.clear();
      _ref = node.prop;
      for (key in _ref) {
        value = _ref[key];
        new PropRow(this, _.cid(), key, value);
      }
      if (node.type === 'data') {
        addToPoolBtn = document.createElement('button');
        addToPoolBtn.innerText = 'Pass on';
        addToPoolBtn.className = 'prop-btn';
        addToPoolBtn.onclick = function() {
          console.log(node);
          return Data.get().members[node.name].output();
        };
        return this.add({
          domElement: addToPoolBtn
        });
      }
    };

    return DataPanel;

  })(View);
  return this.Bottombar.DataPanel = DataPanel;
})();
