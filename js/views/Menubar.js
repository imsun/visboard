var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var Menubar;
  Menubar = (function(_super) {
    __extends(Menubar, _super);

    function Menubar() {
      return Menubar.__super__.constructor.apply(this, arguments);
    }

    Menubar.prototype.init = function(id) {
      this.id = id;
      this.domElement = document.createElement('div');
      this.domElement.id = id;
      return this.domElement.className = 'menubar';
    };

    Menubar.MenuItem = (function(_super1) {
      __extends(_Class, _super1);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.init = function(id, name) {
        this.id = id;
        this.name = name;
        this.domElement = document.createElement('li');
        this.domElement.id = id;
        this.domElement.className = 'menu-item';
        return this.domElement.innerHTML = name;
      };

      return _Class;

    })(View);

    Menubar.Menu = (function(_super1) {
      __extends(_Class, _super1);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.init = function(id, name) {
        var list, title;
        this.id = id;
        this.name = name;
        title = document.createElement('span');
        title.id = _.cid();
        title.className = 'menu-title';
        title.innerHTML = name;
        list = document.createElement('ul');
        list.id = _.cid();
        list.className = 'menu-list';
        this.domElement = document.createElement('div');
        this.domElement.id = id;
        this.domElement.className = 'menu';
        this.domElement.titleEl = title;
        this.domElement.appendChild(title);
        this.domElement.listEl = list;
        this.domElement.appendChild(list);
        this.domElement.addEventListener('mouseover', function(e) {
          return this.listEl.className = 'menu-list show';
        });
        return this.domElement.addEventListener('mouseout', function(e) {
          return this.listEl.className = 'menu-list';
        });
      };

      _Class.prototype.add = function(child) {
        this.children[child.id] = child;
        return this.domElement.listEl.appendChild(child.domElement);
      };

      return _Class;

    })(View);

    return Menubar;

  })(View);
  this.addMenubar = function(editor) {
    var axis, circle, coordinate, dataMenu, fileMenu, logo, menubar, newCluster, newData, newFilter, newScale, primitiveMenu, scatterPlot, templateMenu;
    menubar = new Menubar(editor);
    logo = new Menubar.Menu(menubar, 'logo', '<span>Vis</span>Composer');
    fileMenu = new Menubar.Menu(menubar, 'file', 'File');
    fileMenu.domElement.style.width = '50px';
    new Menubar.MenuItem(fileMenu, 'import', 'Import');
    new Menubar.MenuItem(fileMenu, 'export', 'Export');
    dataMenu = new Menubar.Menu(menubar, 'data', 'Workflow');
    dataMenu.domElement.style.width = '70px';
    newData = new Menubar.MenuItem(dataMenu, 'newData', 'New data');
    newData.domElement.addEventListener('click', function(e) {
      return Reader.upload();
    });
    newFilter = new Menubar.MenuItem(dataMenu, 'newFilter', 'Filter');
    newFilter.domElement.addEventListener('click', function(e) {
      return new (Data.tools().Filter)();
    });
    newCluster = new Menubar.MenuItem(dataMenu, 'newCluster', 'Cluster');
    newCluster.domElement.addEventListener('click', function(e) {
      return new (Data.tools().Cluster)();
    });
    newScale = new Menubar.MenuItem(dataMenu, 'newScale', 'Scale');
    newScale.domElement.addEventListener('click', function(e) {
      return new (Data.tools().Scale)();
    });
    primitiveMenu = new Menubar.Menu(menubar, 'primitive', 'Primitive');
    coordinate = new Menubar.MenuItem(primitiveMenu, 'group', 'Group');
    coordinate.domElement.addEventListener('click', function(e) {
      return new Group();
    });
    axis = new Menubar.MenuItem(primitiveMenu, 'axis', 'Axis');
    axis.domElement.addEventListener('click', function(e) {
      new Axis();
      if (typeof Renderer !== "undefined" && Renderer !== null) {
        return Renderer.renderAll();
      }
    });
    circle = new Menubar.MenuItem(primitiveMenu, 'circle', 'Circle');
    circle.domElement.addEventListener('click', function(e) {
      new Circle();
      if (typeof Renderer !== "undefined" && Renderer !== null) {
        return Renderer.renderAll();
      }
    });
    templateMenu = new Menubar.Menu(menubar, 'template', 'Template');
    scatterPlot = new Menubar.MenuItem(templateMenu, 'scatterplot', 'Scatterplot');
    scatterPlot.domElement.addEventListener('click', function(e) {
      new Scatterplot();
      if (typeof Renderer !== "undefined" && Renderer !== null) {
        return Renderer.renderAll();
      }
    });
    return menubar;
  };
  return this.Menubar = Menubar;
})();
