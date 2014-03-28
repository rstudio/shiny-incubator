jQuery(function($) {
  var TableInputValidator = function() {
  };
  (function() {
    this.onkeypress = function(el, config, key) {
      return true;
    };
    this.oninput = function(el, config, evt) {
    };
    this.validate = function(el, config) {
      return true;
    };
    this.parseInput = function(el) {
      return el.text();
    };
  }).call(TableInputValidator.prototype);

  var integerTableValidator = new TableInputValidator();
  $.extend(integerTableValidator, {
    onkeypress: function(el, config, key) {
      return key >= 48 && key <= 57; // 0-9
    },
    oninput: function(el, config, evt) {
      var value = el.text();
      var num = value.replace(/[^0-9]/g, '');
      if (value != num) {
        el.text(num);
      }
    },
    validate: function(el, config) {
      var value = el.text();
      if (config.data('required') === true && /^\s*$/.test(value)) {
        window.alert('A value is required');
        return false;
      }
      return true;
    },
    parseInput: function(el) {
      return parseInt(el.text(), 10);
    }
  });

  var numericTableValidator = new TableInputValidator();
  $.extend(numericTableValidator, {
    onkeypress: function(el, config, key) {
      return (key >= 48 && key <= 57) ||  // 0-9
         key == 46 ||                     // period
         key == 44;                       // comma
    },
    oninput: function(el, config, evt) {
      var value = el.text();
      if (/^[0-9]*([\.,][0-9]*)?$/.test(value))
        return;

      var floatVal = parseFloat(el.text());
      if (isNaN(floatVal))
        el.text('');
      else
        el.text('' + floatVal);
    },
    validate: function(el, config) {
      var value = el.text();
      if (config.required === true && /^\s*$/.test(value)) {
        window.alert('A value is required');
        return false;
      }
      return true;
    },
    parseInput: function(el) {
      return parseFloat(el.text());
    }
  });
  
  function moveFocus(el, voffset, hoffset) {
    var cell = el.parents('td');
    if (!cell)
      return;
    var row = cell.parents('tr');
    if (!row)
      return;
    
    var cells = cell.parent().children('td');
    var cellIndex = cells.index(cell);
    var rows = row.parent().children('tr');
    var rowIndex = rows.index(row);
    
    cellIndex += hoffset;
    cellIndex = Math.max(0, Math.min(cells.length-1, cellIndex));
    rowIndex += voffset;
    rowIndex = Math.max(0, Math.min(rows.length-1, rowIndex));
    
    try {
      var newCell = $($(rows.get(rowIndex)).children('td').get(cellIndex));
      var newEl = newCell.find('div').first();
      if (newEl)
        newEl.focus();
    } catch (e) {
    }
  }

  $(document).on('keydown', '.tableinput td>div', function(evt) {
    var voffset = 0;
    var hoffset = 0;
    switch (evt.which) {
      case 13: // Enter
      case 40: // Down arrow
        voffset = 1;
        break;
      /*
      case 37: // Left arrow
        hoffset = -1;
        break;
      */
      case 38: // Up arrow
        voffset = -1;
        break;
      /*
      case 39: // Right arrow
        hoffset = 1;
        break;
      */
      case 27: // Esc
        $(evt.target).blur();
        return;
    }
    
    if (voffset || hoffset) {
      $(evt.target).trigger('blur');
      moveFocus($(evt.target), voffset, hoffset);
      evt.preventDefault();
    }
  });
  $(document).on('keypress', '.tableinput td>div', function(evt) {
    var el = $(evt.target);
    if (!getValidator(el).onkeypress(el, getConfig(el), evt.which))
      evt.preventDefault();
  });
  $(document).on('input', '.tableinput td>div', function(evt) {
    var el = $(evt.target);
    if (!getValidator(el).oninput(el, getConfig(el), evt))
      evt.preventDefault();
  });

  $(document).on('focus', '.tableinput td>div', function(evt) {
    if (evt.target.contentEditable == "true")
      return;
    evt.target.contentEditable = "true";
    evt.target.focus();

    var el = $(evt.target);
    el.data('oldValue', getValidator(el).parseInput(el));
  });
  
  $(document).on('click', '.tableinput-settings', function(evt) {
    var el = $(evt.target);    
    var editor = el.parents('.tableinput-container').children('.tableinput-editor');
    var tbody = el.parents('.tableinput-container').find('.tableinput>tbody');
    var rowcount = editor.find('.tableinput-rowcount');
    var colcount = editor.find('.tableinput-colcount');
    rowcount.val(tbody.children().size());
    colcount.val(tbody.children().size() == 0 ? '' : tbody.children().first().children().size());
    editor.modal({});
  });
  
  $(document).on('click', '.btn.tableinput-edit', function(evt) {
    var el = $(evt.target);
    var container = el.parents('.tableinput-container');
    var tbody = container.children('.tableinput').children('tbody');
    var editor = container.children('.tableinput-editor');
    
    var rows = editor.find('.tableinput-rowcount');
    var cols = editor.find('.tableinput-colcount');
    var rowVal = parseInt(rows.val(), 10);
    var colVal = parseInt(cols.val(), 10);
    
    if (isNaN(rowVal) || rowVal <= 0) {
      rows.get(0).focus();
      rows.get(0).select();
      return;
    }
    if (isNaN(colVal) || colVal <= 0) {
      cols.get(0).focus();
      cols.get(0).select();
      return;
    }
    
    editor.modal('hide');
    
    resize(tbody, rowVal, colVal);
  });
  
  $(document).on('click', '.tableinput-plusrow', function(evt) {
    evt.preventDefault();
    var el = $(evt.target);
    var tbody = el.parents('.tableinput-container').find('.tableinput>tbody');
    resize(tbody, tbody.children().size() + 1, null);
  });
  
  $(document).on('click', '.tableinput-minusrow', function(evt) {
    evt.preventDefault();
    var el = $(evt.target);
    var tbody = el.parents('.tableinput-container').find('.tableinput>tbody');
    resize(tbody, Math.max(1, tbody.children().size() - 1), null);
  });
  
  function resize(tbody, rowVal, colVal) {
    var template = '<td><div tabindex="0"></div></td>';
    
    var origRows = tbody.children().size();
    var origCols = origRows == 0 ? 0 : tbody.children().first().children().size();
    
    if (colVal === null)
      colVal = origCols;
    
    if (rowVal < origRows) {
      tbody.children().slice(rowVal).remove();
    } else if (rowVal > origRows) {
      while (rowVal-- > origRows) {
        var tr = $('<tr>');
        for (var i = 0; i < colVal; i++) {
          tr.append(template);
        }
        tbody.append(tr);
      }
    }
    
    if (colVal != origCols && origRows != 0) {
      var rowsToModify = tbody.children().slice(0, origRows);
      if (colVal > origCols) {
        while (colVal-- > origCols) {
          rowsToModify.append(template);
        }
      } else {
        rowsToModify.each(function() {
          $(this).children().slice(colVal).remove();
        });
      }
    }
    
    tbody.parent().change();
  }
  
  function getConfig(el, idx) {
    if (el.data('config'))
      return el.data('config').data();
    
    if (typeof(idx) == 'undefined') {
      idx = el.data('index');
      if (typeof(idx) != 'number') {
        var cell = el.parent();
        idx = cell.parent().children().index(cell);
        el.data('index', idx);
      }
    }
    
    var col = $(el.parents('table').find('colgroup').children().get(idx));
    el.data('config', col);
    return col.data();
  }
  
  function getValidator(el, idx) {
    if (el.data('validator'))
      return el.data('validator');
      
    var config = getConfig(el, idx);
    var type = config.type || 'string';

    var validator = new TableInputValidator();
    if (type === 'integer')
      validator = integerTableValidator;
    else if (type === 'numeric')
      validator = numericTableValidator;

    el.data('validator', validator);
    
    return validator;
  }
  
  $(document).on('blur', '.tableinput td>div', function(evt) {
    evt.target.contentEditable = "false";

    var el = $(evt.target);
    var validator = getValidator(el);
    if (!validator.validate(el, getConfig(el)))
      evt.target.focus();

    var oldValue = el.data('oldValue');
    var newValue = validator.parseInput(el);
    if (oldValue !== newValue)
      el.change();
  });
  
  var tableInputBinding = new Shiny.InputBinding();
  $.extend(tableInputBinding, {
    find: function(scope) {
      return $(scope).find('table.tableinput');
    },
    getValue: function(el) {
      var data = [];
      var dataTable = {};
      $(el).find('tr').each(function() {
        var divs = $(this).find('td>div');
        if (divs.length) {
          divs.each(function(i, div) {
            if (data.length <= i) {
              data.push([]);
              dataTable['V' + (i+1)] = data[data.length-1];
            }
            data[i].push(getValidator($(div)).parseInput($(div)));
          });
        }
      });
      
      if (data.length > 0 && data[0].length != data[data.length-1].length) {
        throw "Error retrieving data from table--data was not rectangular";
      }
      return data;
    },
    setValue: function(el) {
    },
    getType: function(el) {
      return "shiny.matrix";
    },
    subscribe: function(el, callback) {
      $(el).on('change.tableinput', function(e) { callback(); });
    },
    unsubscribe: function(el) {
      $(el).off('')
    }
  });
  Shiny.inputBindings.register(tableInputBinding);
});
