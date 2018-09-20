(function ($) {
  // -- Set new default font family and font color to mimic Bootstrap's default styling
  Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
  Chart.defaults.global.defaultFontColor = '#292b2c';

  // -- Shared function
  const requestData = function(settings, ...callbacks) {
    const trigger = function(settings, callbacks) {
      if (callbacks && callbacks.length > 0) { 
        return trigger(callbacks.shift()(settings), callbacks);
      }
      return settings;
    }

    $.get(settings.url, function (data) {
      settings.response_data = data;
      trigger(settings, callbacks);
    })
  }

  // -- Bar Chart 
  const MonthlyExpReportBarChart = {
    create: function (selector, url, options = {}, callback) {

      const default_data = function () {
        const result = {};
        const d = new Date();
        for (let i = 0; i < 6; i++) {
          result[$.format.date(d.toUTCString(), 'yyyy-MM-01')] = 0;
          d.setMonth(d.getMonth() - 1);
        };
        return result;
      }();
  
      const settings = $.extend({
        selector: selector,
        url: url,
        data: default_data,
        yAxesMax: 100,
        yAxesMaxTicksLimit: 5,
        last_updated: new Date()
      }, options);
  
      this.requestData(settings, this.processData, this.build, callback);
    },
    requestData: requestData

  }

  MonthlyExpReportBarChart.build = function (settings) {
    const _settings = settings;
    const labels = [];
    const values = [];
    $.each(Object.keys(_settings.data).sort(), function (idx, key) {
      labels.push($.format.date(new Date(key + "T00:00:00"), 'MMM-yyyy'));
      values.push(_settings.data[key]);
    });

    const ctx = $(_settings.selector);
    const barChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: "Expense",
          backgroundColor: "rgba(2,117,216,1)",
          borderColor: "rgba(2,117,216,1)",
          data: values
        }],
      },
      options: {
        scales: {
          xAxes: [{
            gridLines: {
              display: false
            },
            ticks: {
              maxTicksLimit: 6
            }
          }],
          yAxes: [{
            ticks: {
              min: 0,
              max: _settings.yAxesMax,
              maxTicksLimit: _settings.yAxesMaxTicksLimit
            },
            gridLines: {
              display: true
            }
          }],
        },
        legend: {
          display: true
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const label = `${data.datasets[tooltipItem.datasetIndex].label}: ` || '';
              return `${label}$${tooltipItem.yLabel}`;
            }
          }
        }
      }
    });
    return _settings;
  }

  MonthlyExpReportBarChart.processData = function (settings) {
    const _settings = settings;
    const response_data = _settings.response_data;
    const raw_data = response_data.data;
    const last_updated = response_data.last_updated;

    const _transformed_data = {};
    $.each(raw_data, function (index, obj) {
      _transformed_data[$.format.date(new Date(obj.month), 'yyyy-MM-01')] = obj.total;
    });
    const transformed_data = $.extend(_settings.data, _transformed_data);

    let max = 0;
    $.each(Object.keys(transformed_data), function (index, key) {
      max = Math.max(max, transformed_data[key]);
    });

    _settings.last_updated = last_updated
    _settings.data = transformed_data;
    _settings.yAxesMax = MonthlyExpReportBarChart.helpers.ceiling(max, _settings.yAxesMaxTicksLimit);
    return _settings;
  }

  MonthlyExpReportBarChart.helpers = {
    ceiling: function (value, ticksLimit) {
      const _findTick = function (value, multiplier, index = 1) {
        const result = multiplier * index;
        if (result > value) {
          return result;
        } else {
          return _findTick(value, multiplier, index += 1);
        }
      }
  
      let factor = ticksLimit % 5;
      if (factor == 0) {
        factor = 5;
      }
      const tickValue = value / ticksLimit;
      if (tickValue < 1) {
        const strValue = tickValue.toString();
        const matcher = strValue.match(/0(\.0*)/);
        const precision = (matcher) ? matcher[1].length : 0;
        const multiplier = Math.pow(10, precision * -1);
        return _findTick(tickValue, multiplier) * factor;
      } else {
        const iValue = parseInt(tickValue);
        const digit = iValue.toString().length - 1;
        const multiplier = Math.pow(10, digit);
        return _findTick(iValue, multiplier) * factor;
      }
    }
  } 

  // -- Pie Chart 
  const ExpenseCategoryReportPieChart = {
    create: function(selector, url, options = {}, callback) {
      const settings = $.extend({
        selector: selector,
        url: url,
        data: { 'None': 1 }
      }, options);
  
      this.requestData(settings, this.processData, this.build, callback);
    },
    requestData: requestData
  } 

  ExpenseCategoryReportPieChart.build = function(settings) {
    const _settings = settings;
    const data = _settings.data;
    const labels = [];
    const values = [];
    $.each(Object.keys(data), function(idx, key) {
      labels.push(key.replace(/^\w/, c => c.toUpperCase()));
      values.push(data[key]);
    });

    const ctx = $(_settings.selector);
    const myPieChart = new Chart(ctx, {
      type: 'pie',
      data: {
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: ['#007bff', '#dc3545', '#ffc107', '#28a745', '#e500ff', '#ff6a00'],
        }],
      },
      options: {
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const idx = tooltipItem.index;                 
              const label = `${data.labels[idx]}: ` || '';
              return `${label}$${data.datasets[0].data[idx]}`;
            }
          }
        }
      }
    });
    return _settings;
  }

  ExpenseCategoryReportPieChart.processData = function(settings) {
    const _settings = settings;
    const response_data = _settings.response_data;
    _settings.data = response_data.data;
    _settings.last_updated = response_data.last_updated;
    return _settings;
  }

  $(document).on('turbolinks:load', function () {
    const updateFooterTime = function(selector, last_updated) {
      const footer = $(selector);
      if (footer.length) {
        footer.text(`Updated ${ $.format.prettyDate(last_updated) } at ${ $.format.date(new Date(last_updated).toLocaleString(), 'hh:mm a')}`);
      }
    }

    const $expMonthlyReport = $('#expenses_monthly_report');
    if ($expMonthlyReport.length) {
      MonthlyExpReportBarChart.create($expMonthlyReport, '/expenses/reports/monthly_data', {}, function (settings) {
        updateFooterTime('#expenses_monthly_report_last_updated', settings.last_updated);
      });
    }

    const $expCategoryReport = $('#expense_category_report');
    if ($expCategoryReport.length) {
      ExpenseCategoryReportPieChart.create($expCategoryReport, '/expenses/reports/category_data', {}, function (settings) {
        updateFooterTime('#expense_category_report_last_updated', settings.last_updated);
      });
    }
  });



})(jQuery);