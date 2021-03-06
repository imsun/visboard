// Generated by CoffeeScript 1.8.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Sidebar;
  Sidebar = (function(_super) {
    __extends(Sidebar, _super);

    function Sidebar() {
      return Sidebar.__super__.constructor.apply(this, arguments);
    }

    Sidebar.prototype.init = function(id, title) {
      var titleEl;
      this.id = id;
      this.title = title;
      this.domElement = document.createElement('div');
      this.domElement.id = this.id;
      this.domElement.className = 'sidebar';
      if (this.title) {
        titleEl = document.createElement('h2');
        titleEl.className = 'sidebar-title';
        titleEl.innerText = this.title;
        this.domElement.titleEl = titleEl;
        return this.domElement.appendChild(titleEl);
      }
    };

    return Sidebar;

  })(View);
  this.addSidebar = function(editor) {
    return new Sidebar(editor, _.cid(), 'Primitives');
  };
  return this.Sidebar = Sidebar;
})();
