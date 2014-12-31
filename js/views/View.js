// Generated by CoffeeScript 1.8.0
var __slice = [].slice;

(function() {
  var View;
  View = (function() {
    function View() {
      var config, parent;
      parent = arguments[0], config = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.parent = parent;
      this.children = {};
      this.domElement;
      this.init.apply(this, config);
      this.id = this.id || _.cid();
      if ((this.domElement != null) && this.domElement.id === 'undefined') {
        this.domElement.id = _.cid();
      }
      if (parent != null) {
        this.parent.add(this);
      }
    }

    View.prototype.init = function() {
      var config;
      config = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.id = _.cid();
      this.domElement = document.createElement('div');
      this.domElement.id = _.cid();
      return this.domElement.className = 'view';
    };

    View.prototype.add = function(child) {
      this.children[child.id] = child;
      return this.domElement.appendChild(child.domElement);
    };

    View.prototype.clear = function() {
      this.children = [];
      return this.domElement.innerHTML = '';
    };

    return View;

  })();
  return this.View = View;
})();
