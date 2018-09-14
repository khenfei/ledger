$(function() {
  'use strict'
  $('.error[data-toggle="popover"]').popover({
    container: 'body',
    template: '<div class="popover popover-error" role="tooltip"><div class="arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>'
  });

  $('.form-control.error').change(function() {
    $this = $(this);
    $this.removeClass('error');
    $this.next('i').remove();
  });

  let convert2float = function(value, defaultValue = 0) {
    let v = parseFloat(value);
    return isNaN(v)? defaultValue : v;
  }

  let roundUp = function(value, precision = 0) {
    let p = (precision < 0)? 0 : precision;
    let pv = Math.pow(10, p);
    return (Math.round(value * pv) / pv).toFixed(p);
  }

  $('.form-field-number').change(function() {
    let $this = $(this);
    let v = convert2float($this.val());
    let rounded = roundUp(v, 2);
    $this.val(rounded);
  });
});

