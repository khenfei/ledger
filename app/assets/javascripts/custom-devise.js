(function($) {
  'use strict'; // Start of use strict
  $(document).on('turbolinks:load', function() {
    $('.info[data-toggle="popover"]').popover({
      template: '<div class="popover popover-info" role="tooltip"><div class="arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>'
    });
  });
})(jQuery);