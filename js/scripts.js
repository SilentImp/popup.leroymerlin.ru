var Popup,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Popup = (function() {
  function Popup() {
    this.fix = bind(this.fix, this);
    this.open = bind(this.open, this);
    this.close = bind(this.close, this);
    this.showSuccess = bind(this.showSuccess, this);
    this.resize = bind(this.resize, this);
    this.widget = $('.popup.popup_form');
    if (this.widget.length === 0) {
      return;
    }
    this.resize();
    this.success = $('.popup.popup_success');
    this.lightbox = $('.popup__lightbox');
    $('.popup__close, .popup__submit_close').on('click', this.close);
    $('.popup__input').on('change', this.fix);
    this.widget.on('submit', this.showSuccess);
  }

  Popup.prototype.resize = function(event) {
    this.vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    if (this.widget.outerHeight() > this.vh) {
      return this.widget.addClass('popup_scrolable');
    } else {
      return this.widget.removeClass('popup_scrolable');
    }
  };

  Popup.prototype.showSuccess = function(event) {
    var options, options_form, props, props_success;
    event.preventDefault();
    props = {
      marginTop: -this.widget.outerHeight() - 30 - this.vh
    };
    props_success = {
      marginTop: '0'
    };
    options = {
      duration: 500
    };
    options_form = {
      duration: 500,
      complete: (function(_this) {
        return function() {
          return _this.current = _this.success;
        };
      })(this)
    };
    this.widget.velocity("stop").velocity(props, options);
    return this.success.velocity("stop").velocity(props_success, options_form);
  };

  Popup.prototype.close = function() {
    var options, props;
    props = {
      marginTop: '-200vh'
    };
    options = {
      duration: 500
    };
    this.current.velocity("stop").velocity(props, options);
    return this.lightbox.velocity("stop").velocity("fadeOut", options);
  };

  Popup.prototype.open = function() {
    var options, options_form, props;
    props = {
      marginTop: 0
    };
    options = {
      duration: 500
    };
    options_form = {
      duration: 500,
      complete: (function(_this) {
        return function() {
          return _this.current = _this.widget;
        };
      })(this)
    };
    this.widget.velocity("stop").velocity(props, options_form);
    return this.lightbox.velocity("stop").velocity("fadeIn", options);
  };

  Popup.prototype.fix = function(event) {
    var input;
    input = $(event.currentTarget);
    if (input.val().trim() !== "") {
      return input.attr('data-changed', true);
    } else {
      return input.get(0).removeAttr('data-changed');
    }
  };

  return Popup;

})();

$(document).ready(function() {
  var popup;
  popup = new Popup;
  return popup.open();
});
