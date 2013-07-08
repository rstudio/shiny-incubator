(function() {
  function updateProgress($progress, data) {
    if (typeof(data.message) !== 'undefined') {
      $progress.find('.progress-message').text(data.message);
    }
    if (typeof(data.detail) !== 'undefined') {
      $progress.find('.progress-detail').text(data.detail);
    }
    if (typeof(data.value) !== 'undefined') {
      if (data.value !== null) {
        $progress.find('.progress').show();
        $progress.find('.bar').width((data.value*100) + '%');
      }
      else {
        $progress.find('.progress').hide();
      }
    }
  }

  Shiny.addCustomMessageHandler(
    'shiny-progress-open',
    function(data) {
      var num = $('.shiny-progress.open').length + 1;

      var $progress = $('<div class="shiny-progress open"><div class="progress-message"></div><div class="progress-detail"></div><div class="progress progress-striped active"><div class="bar"></div></div></div>');
      $progress.attr('id', data.id);
      $progress.css('top', (20 * num) + 'px');
      $progress.css('right', (20 * num) + 'px');
      $progress.hide();
      $progress.find('.progress').hide();
      $('body').append($progress);
    }
  );

  Shiny.addCustomMessageHandler(
    'shiny-progress-update',
    function(data) {
      var $progress = $('#' + data.id + '.shiny-progress');
      updateProgress($progress, data);
      $progress.show();
    }
  );

  Shiny.addCustomMessageHandler(
    'shiny-progress-close',
    function(data) {
      var $progress = $('#' + data.id + '.shiny-progress');
      $progress.removeClass('open');
      $progress.fadeOut({
        complete: function() {$progress.remove();}
      });
    }
  );

})();