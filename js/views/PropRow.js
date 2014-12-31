// Generated by CoffeeScript 1.8.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

(function() {
  var PropRow;
  PropRow = (function(_super) {
    __extends(PropRow, _super);

    function PropRow() {
      return PropRow.__super__.constructor.apply(this, arguments);
    }

    PropRow.prototype.init = function(id, key, prop) {
      var changeRange, codeButton, endEl, event, option, optionInfo, propLabelEl, propValue, propValueEl, set, startEl, temp, _i, _len, _ref;
      this.id = id;
      this.prop = prop;
      if (_.isType(prop.value, 'Function')) {
        propValue = prop.value();
      } else {
        propValue = prop.value;
      }
      this.domElement = document.createElement('div');
      this.domElement.id = key;
      this.domElement.className = 'prop-row';
      propLabelEl = document.createElement('label');
      propLabelEl.id = _.cid();
      propLabelEl.className = 'prop-label';
      propLabelEl.innerHTML = prop.name;
      event = 'change';
      switch (prop.type) {
        case 'title':
          propLabelEl.className += ' prop-title';
          break;
        case 'label':
          propValueEl = document.createElement('input');
          propValueEl.className = 'prop-value';
          propValueEl.type = 'text';
          propValueEl.readOnly = 'readOnly';
          propValueEl.value = propValue;
          break;
        case 'text':
          propValueEl = document.createElement('input');
          propValueEl.className = 'prop-value';
          propValueEl.type = 'text';
          propValueEl.value = propValue;
          break;
        case 'number':
          propValueEl = document.createElement('input');
          propValueEl.className = 'prop-value';
          propValueEl.type = 'text';
          propValueEl.value = propValue;
          break;
        case 'boolean':
          propValueEl = document.createElement('input');
          propValueEl.className = 'prop-value';
          propValueEl.type = 'checkbox';
          propValueEl.checked = propValue;
          propValueEl.addEventListener(event, function(e) {
            return prop.listener(this.checked);
          });
          break;
        case 'select':
          propValueEl = document.createElement('select');
          propValueEl.className = 'prop-value';
          if (_.isType(prop.set, 'Function')) {
            set = prop.set();
          } else {
            set = prop.set;
          }
          for (_i = 0, _len = set.length; _i < _len; _i++) {
            optionInfo = set[_i];
            option = document.createElement('option');
            option.value = optionInfo.value;
            option.innerHTML = optionInfo.name;
            if (optionInfo.value === propValue) {
              option.setAttribute('selected', 'selected');
            }
            propValueEl.appendChild(option);
          }
          break;
        case 'range':
          propValueEl = document.createElement('span');
          propValueEl.className = 'prop-value prop-range';
          startEl = document.createElement('input');
          startEl.type = 'text';
          startEl.value = propValue[0];
          endEl = document.createElement('input');
          endEl.type = 'text';
          endEl.value = propValue[1];
          if (prop.listener != null) {
            changeRange = function() {
              return prop.listener([startEl.value, endEl.value]);
            };
            startEl.addEventListener(event, changeRange);
            endEl.addEventListener(event, changeRange);
          }
          temp = document.createElement('span');
          temp.innerText = ' - ';
          propValueEl.appendChild(startEl);
          propValueEl.appendChild(temp);
          propValueEl.appendChild(endEl);
      }
      this.domElement.appendChild(propLabelEl);
      if (propValueEl != null) {
        this.domElement.appendChild(propValueEl);
        if ((prop.listener != null) && !((_ref = prop.type) === 'range' || _ref === 'boolean')) {
          propValueEl.addEventListener(event, function() {
            return prop.listener(this.value);
          });
        }
      }
      if (prop.code != null) {
        codeButton = document.createElement('button');
        codeButton.className = 'prop-code';
        codeButton.innerText = '</>';
        codeButton.addEventListener('click', function() {
          return Codeeditor.show(prop.code, prop.enableCode, function(code, flag) {
            prop.code = code;
            prop.enableCode = flag;
            if (flag) {
              propValueEl.style.display = 'none';
              codeButton.style.float = 'left';
            } else {
              propValueEl.style.display = ' inline-block';
              codeButton.style.float = 'right';
            }
            if (prop.codeListener != null) {
              prop.codeListener(code, flag);
            }
            return Renderer.renderAll();
          });
        });
        if (prop.enableCode && (propValueEl != null)) {
          propValueEl.style.display = 'none';
          codeButton.style.float = 'left';
        }
        return this.domElement.appendChild(codeButton);
      }
    };

    return PropRow;

  })(View);
  return this.PropRow = PropRow;
})();