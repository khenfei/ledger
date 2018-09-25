(function ($) {
  $(document).on('turbolinks:load', function () {

    $('#read-button').click(function(e) {
      $this = $(this);
      $this.prop('hidden', 'true');
      typewriter({
        el: document.getElementById('typed-text'),
        data: $('#story-list > li').map(function () {
          return this.innerText;
        }).toArray()
      });
    })

    

    function typewriter(options) {
      const settings = $.extend({
        el: undefined,
        data: undefined,
        displayMaxLine: 20,
        textSpeed: 200,
        charSpeed: 100
      }, options);

      const errors = validate(settings);
      if (errors.length > 0) {
        errors.forEach(function (value) {
          console.error(value);
        });
      } else {
        processText(0, settings.data.length, settings);
      }
    }

    function validate(settings) {
      const errors = [];
      if (settings.el === undefined) {
        errors.push('Attribute \'el\' is required but undefined. Please define it.');
      }
      if (settings.data === undefined) {
        errors.push('Attribute \'data\' is required but undefined. Please define it.');
      } else if (!isArray(settings.data)) {
        errors.push('Attribute \'data\' is not an Array object. Please define an Array object.');
      }
      return errors;
    }

    function processText(index, length, settings) {
      if (index < length) {
        const text = settings.data[index];
        const needScroll = index + 1 > settings.displayMaxLine;
        if (needScroll) {
          $(settings.el).find(':first-child').remove();
        }
        $(settings.el).append($('<p>'));
        setTimeout(processChar, settings.textSpeed, 0, text.length, text, {
          index: index,
          length: length
        }, settings);
      }
    }

    function processChar(index, length, dataText, row, settings) {
      const elem = $(settings.el).find(':last-child');
      if (index < length) {
        elem.text(elem.text().slice(0, -1) + dataText.charAt(index) + '_');
        setTimeout(processChar, settings.charSpeed, index + 1, length, dataText, row, settings);
      } else {
        elem.text(elem.text().slice(0, -1));
        processText(row.index + 1, row.length, settings);
      }
    }

    function getType(obj) {
      return Object.prototype.toString.call(obj).slice(8, -1);
    }

    function isArray(obj) {
      return getType(obj) === "Array";
    }
  });
})(jQuery);