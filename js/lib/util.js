// Generated by CoffeeScript 1.8.0
(function() {
  var $, cid, _;
  $ = function(selector) {
    var index, main;
    if (selector == null) {
      return;
    }
    main = selector;
    index = Math.max.apply(this, [' ', '+', '>'].map(function(op) {
      return selector.lastIndexOf(op);
    }));
    if (index > 0) {
      main = selector.substr(index);
    }
    if (main[0] === '#') {
      return document.getElementById(selector.substr(1));
    }
    return document.body.querySelectorAll(selector);
  };
  _ = {};
  _.isType = function(obj, type) {
    return Object.prototype.toString.call(obj) === ("[object " + type + "]");
  };
  _.extend = function(obj, prop) {
    var key, value;
    obj = obj || {};
    for (key in prop) {
      value = prop[key];
      obj[key] = value;
    }
    return obj;
  };
  _.getMouseLoc = function(event) {
    return {
      x: event.pageX,
      y: event.pageY
    };
  };
  _.copy = function(obj) {
    return JSON.parse(JSON.stringify(obj));
  };
  cid = 0;
  _.cid = function() {
    return 'cid' + cid++;
  };
  if (typeof exports !== "undefined" && exports !== null) {
    exports._ = _;
    return exports.$ = $;
  } else {
    this._ = _;
    return this.$ = $;
  }
})();
