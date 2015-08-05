var Popup,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Popup = (function() {
  function Popup() {
    this.fix = bind(this.fix, this);
    this.open = bind(this.open, this);
    this.close = bind(this.close, this);
    this.onDataSend = bind(this.onDataSend, this);
    this.showSuccess = bind(this.showSuccess, this);
    this.resize = bind(this.resize, this);
    this.widget = $('.popup.popup_form');
    if (this.widget.length === 0) {
      return;
    }
    this.transforms = $('html').hasClass('no-csstransforms');
    this.resize();
    this.form = this.widget.find('form.popup__subscribe');
    this.form.attr('novalidate', 'novalidate');
    this.form.on('submit', this.showSuccess);
    this.success = $('.popup.popup_success');
    this.lightbox = $('.popup__lightbox');
    $('.popup__close, .popup__submit_close').on('click', this.close);
    $('.popup__input').on('change', this.fix);
    $(window).on('resize', this.resize);
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
    var email, email_input, email_regex, error, name, name_input;
    event.preventDefault();
    error = false;
    email_regex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
    email_input = this.form.find('.popup__input_email');
    email = email_input.val().trim();
    name_input = this.form.find('.popup__input_name');
    name = name_input.val().trim();
    if (email.length === 0) {
      error = true;
      email_input.addClass('popup__input_error');
    }
    if (name.length < 2) {
      error = true;
      name_input.addClass('popup__input_error');
    } else {
      name_input.removeClass('popup__input_error');
    }
    if (!email_regex.test(email)) {
      error = true;
      email_input.addClass('popup__input_error');
    } else {
      email_input.removeClass('popup__input_error');
    }
    if (error) {
      return;
    }
    return $.post(this.form.attr('action'), this.form.serialize()).complete(this.onDataSend);
  };

  Popup.prototype.onDataSend = function() {
    var height, mt, options, options_form, props, props_success;
    this.form.get(0).reset();
    mt = "0px";
    if (this.transforms === true) {
      mt = -(this.widget.outerHeight() / 2) + "px";
    }
    height = -this.widget.outerHeight() - 30 - this.vh;
    props = {
      marginTop: height + "px"
    };
    props_success = {
      marginTop: mt
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
    var height, options, props;
    height = -this.current.outerHeight() - 30 - this.vh;
    props = {
      marginTop: height + "px"
    };
    options = {
      duration: 500
    };
    this.current.velocity("stop").velocity(props, options);
    return this.lightbox.velocity("stop").velocity("fadeOut", options);
  };

  Popup.prototype.open = function() {
    var mt, options, options_form, props;
    mt = "0px";
    if (this.transforms === true) {
      mt = -(this.widget.outerHeight() / 2) + "px";
    }
    props = {
      marginTop: mt
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

if (!String.prototype.trim) {
  (function() {
    String.prototype.trim = function() {
      return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
    };
  })();
}
