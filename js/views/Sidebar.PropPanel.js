var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var PropPanel;
  PropPanel = (function(_super) {
    __extends(PropPanel, _super);

    function PropPanel() {
      return PropPanel.__super__.constructor.apply(this, arguments);
    }

    PropPanel.prototype.init = function(id) {
      this.id = id;
      this.domElement = document.createElement('div');
      this.domElement.id = id;
      this.domElement.className = 'prop-panel';
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return TreePanel.selectListener.push({
          self: this,
          fn: this.display
        });
      }
    };

    PropPanel.prototype.display = function(node) {
      var key, primitive, value, _ref, _results;
      this.clear();
      primitive = node.target;
      _ref = primitive.prop;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        _results.push(new PropRow(this, _.cid(), key, value));
      }
      return _results;
    };

    return PropPanel;

  })(View);
  return this.Sidebar.PropPanel = PropPanel;
})();
