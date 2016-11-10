(function() {
  (function(w) {
    var base;
    if (w.gl == null) {
      w.gl = {};
    }
    if ((base = w.gl).utils == null) {
      base.utils = {};
    }
    w.gl.utils.days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    w.gl.utils.formatDate = function(datetime) {
      return dateFormat(datetime, 'mmm d, yyyy h:MMtt Z');
    };

    w.gl.utils.getDayName = function(date) {
      return this.days[date.getDay()];
    };

    w.gl.utils.localTimeAgo = function($timeagoEls, setTimeago) {
      if (setTimeago == null) {
        setTimeago = true;
      }
      $timeagoEls.each(function() {
        var $el;
        $el = $(this);
        return $el.attr('title', gl.utils.formatDate($el.attr('datetime')));
      });
      if (setTimeago) {
        $timeagoEls.timeago();
        $timeagoEls.tooltip('destroy');
        // Recreate with custom template
        return $timeagoEls.tooltip({
          template: '<div class="tooltip local-timeago" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
        });
      }
    };

    w.gl.utils.shortTimeAgo = function($el) {
      var shortLocale, tmpLocale;
      shortLocale = {
        prefixAgo: null,
        prefixFromNow: null,
        suffixAgo: '之前',
        suffixFromNow: null,
        seconds: '不到 1 分钟',
        minute: '大约 1 分钟',
        minutes: '%d 分钟',
        hour: '大约 1 小时',
        hours: '大约 %d 小时',
        day: '大约 1 天',
        days: '%d 天',
        month: '大约 1 月',
        months: '%d 月',
        year: '大约 1 年',
        years: '%d 年',
        wordSeparator: ' ',
        numbers: []
      };
      tmpLocale = $.timeago.settings.strings;
      $el.each(function(el) {
        var $el1;
        $el1 = $(this);
        return $el1.attr('title', gl.utils.formatDate($el.attr('datetime')));
      });
      $.timeago.settings.strings = shortLocale;
      $el.timeago();
      $.timeago.settings.strings = tmpLocale;
    };

    w.gl.utils.getDayDifference = function(a, b) {
      var millisecondsPerDay = 1000 * 60 * 60 * 24;
      var date1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
      var date2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

      return Math.floor((date2 - date1) / millisecondsPerDay);
    }

  })(window);

}).call(this);
