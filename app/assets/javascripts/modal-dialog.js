(function ($) {
  $(document).on('turbolinks:load', function () {
    $('#dialogModal').on('show.bs.modal', function (event) {
      const button = $(event.relatedTarget);
      const title = button.data('title');
      const body = button.data('body');
      const link = button.data('link');
      const btnLabel = button.data('button-label');
      const action = button.data('action');

      let modal = $(this);
      modal.find('.modal-title').text(title);
      modal.find('.modal-body').text(body);

      let a = modal.find('.modal-footer a');
      a.attr('href', link);
      a.removeAttr('data-method').attr('data-method', action);
      a.removeAttr('rel').attr('rel', button.data('rel'));
      a.text(btnLabel);
    })
  });

})(jQuery);