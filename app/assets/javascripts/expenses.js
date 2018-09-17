(function ($) {
  'use strict';
  const tTag = '<div class="tag badge badge-primary"><span>{value}</span></div>';
  const renderTagsColumn = function (data, type, full, meta) {
    let tagElems = [];
    $.each(data.split(';'), function (index, value) {
      const v = value.trim();
      if (v.length > 0) {
        tagElems.unshift(tTag.replace('{value}', v));
      }
    });
    
    return tagElems.join('&nbsp;');
  }
  $(document).on('turbolinks:load', function () {
    //initialise dataTables
    $('#expense-dataTable').DataTable({
      language: {
        paginate: {
          first: "&lt;&lt;",
          previous: "&lt;",
          next: "&gt;",
          last: "&gt;&gt;"
        }
      },

      processing: true,
      serverSide: true,
      pagingType: "full_numbers",
      retrieve: true,
      responsive: {
        details: {
          renderer: function (api, rowIdx, columns) {
            var data = $.map(columns, function (col, i) {
              return col.hidden ?
                '<tr data-dt-row="' + col.rowIndex + '" data-dt-column="' + col.columnIndex + '">' +
                '<td>' + col.title + ':' + '</td> ' +
                '<td>' + col.data + '</td>' +
                '</tr>' :
                '';
            }).join('');

            return data ?
              $('<table/>').append(data) : false;
          }
        }
      },
      processing: true,
      deferRender: true,
      ajax: {
        url: $('#expense-dataTable').data('source'),
        type: 'POST'
      },
      lengthMenu: [10, 25, 50, 75, 100],
      columns: [
        { "data": "category" },
        { "data": "total" },
        { "data": "paid_at" },
        { "data": "tags" },
        {
          data: "path", orderable: false
        }
      ],
      columnDefs: [
        {
          targets: 0,
          responsivePriority: 1,
          render: function(data, type, full, meta) {
            return data.replace(/^\w/, c => c.toUpperCase());
          }
        },
        {
          targets: 1,
          responsivePriority: 1,
          render: function(data, type, full, meta) {
            return parseFloat(data).toFixed(2);
          }
        },
        {
          targets: 2,
          data: 2,
          responsivePriority: 3,
          render: function (data, type, full, meta) {
            const d = new Date(data);
            return !isNaN(d.valueOf()) ? $.format.date(d.toUTCString(), 'dd-MM-yyyy hh:mm a') : '-';
          }
        },
        {
          targets: 3,
          responsivePriority: 4,
          className: 'none',
          data: 3,
          render: renderTagsColumn
        },
        {
          targets: 4,
          data: 4,
          responsivePriority: 2,
          render: function (data, type, full, meta) {
            const token = data.split(';');
            return '<a href="' + 
              token[0] + '"><i class="fas fa-list"></i></a> | <a href="' + 
              token[1] + '"><i class="fas fa-edit"></i></a> | <a href="' + 
              token[0] + '" data-method="delete" data-confirm="Are you sure?" rel="nofollow"><i class="fas fa-trash-alt"></i></a>';
          }
        }
      ]

    });

    jQuery('.datetimepicker').datetimepicker();
    jQuery('[data-role="tags-input"]').tagsInput();
  });
})(jQuery);