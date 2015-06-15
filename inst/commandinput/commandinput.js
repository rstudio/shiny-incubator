// Custom input binding for a textbox that only sends its value
// when you hit Enter.
commandTextBinding = new Shiny.InputBinding();
$.extend(commandTextBinding, {
  find: function(scope) {
    return $(scope).find("input.command-text");
  },
  getValue: function(el) {
    return $(el).data("committed-value");
  },
  setValue: function(el, value) {
    $(el).data("committed-value", value);
    $(el).val(value);
  },
  subscribe: function(el, callback) {
    $(el).on("keypress.commandTextBinding", function(e) {
      if (e.which == 13) {
        $(el).data("committed-value", $(el).val());
        callback();
        if ($(el).data("autoclear")) {
          $(el).val("");
        }
      }
    });
  },
  unsubscribe: function(el) {
    $(el).off(".commandTextBinding");
  }
});
Shiny.inputBindings.register(commandTextBinding);

