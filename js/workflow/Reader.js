(function() {
  var Reader, uploader;
  Reader = {};
  uploader = document.createElement('input');
  uploader.type = 'file';
  uploader.style.display = 'none';
  uploader.addEventListener('change', function(e) {
    var name, reader;
    reader = new FileReader;
    name = this.files[0].name;
    reader.onload = function(e) {
      var file;
      file = e.target.result;
      new Data(name, Reader.parse(file));
      if (typeof TreePanel !== "undefined" && TreePanel !== null) {
        return TreePanel.select(TreePanel.selected);
      }
    };
    return reader.readAsText(this.files[0], 'utf-8');
  });
  document.body.appendChild(uploader);
  Reader._uploader = uploader;
  Reader.upload = function() {
    return Reader._uploader.click();
  };
  Reader.parse = function(data) {
    var keys, result, rows;
    rows = data.replace(/\n+/g, '\n').replace(/\r+/g, '').trim().split('\n').map(function(row, index) {
      var i, qFlag, result, temp, _i, _ref;
      result = [];
      temp = '';
      qFlag = false;
      for (i = _i = 0, _ref = row.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (row[i] === ',' && !qFlag) {
          result.push(temp);
          temp = '';
        } else if (row[i] === '"') {
          qFlag = !qFlag;
        } else {
          temp += row[i];
        }
      }
      result.push(temp);
      return result;
    });
    keys = rows.shift();
    result = [];
    rows.forEach(function(row) {
      var _row;
      _row = {};
      row.forEach(function(value, index) {
        return _row[keys[index]] = value;
      });
      return result.push(_row);
    });
    return result;
  };
  Reader.read = function(file, callback) {
    var req;
    req = new XMLHttpRequest;
    req.onload = function() {
      return callback(null, Reader.parse(this.responseText));
    };
    req.open('get', file, true);
    return req.send();
  };
  if (typeof exports !== "undefined" && exports !== null) {
    return module.exports = Reader;
  } else {
    return this.Reader = Reader;
  }
})();
