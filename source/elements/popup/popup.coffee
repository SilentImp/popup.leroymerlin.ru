class Popup
  constructor: ->
    @widget = $ '.popup.popup_form'
    if @widget.length == 0
      return

    @resize()

    @form = @widget.find 'form.popup__subscribe'
    @form.attr 'novalidate', 'novalidate'
    @form.on 'submit', @showSuccess

    @success = $ '.popup.popup_success'
    @lightbox = $ '.popup__lightbox'
    $('.popup__close, .popup__submit_close').on 'click', @close
    $('.popup__input').on 'change', @fix

    $(window).on 'resize', @resize

  resize: (event)=>
    @vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    if @widget.outerHeight() > @vh
      @widget.addClass 'popup_scrolable'
    else
      @widget.removeClass 'popup_scrolable'

  showSuccess: (event)=>
    event.preventDefault()

    # TODO Отправка данных на сервер

    error = false

    email_regex = new RegExp "^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$"
    email_input = @form.find '.popup__input_email'
    email = email_input.val().trim()

    name_input = @form.find '.popup__input_name'
    name = name_input.val().trim()

    if email.length == 0
      error = true
      email_input.addClass 'popup__input_error'

    if name.length < 2
      error = true
      name_input.addClass 'popup__input_error'
    else
      name_input.removeClass 'popup__input_error'

    if email_regex.test(email) == false
      error = true
      email_input.addClass 'popup__input_error'
    else
      email_input.removeClass 'popup__input_error'

    if error
      return

    $.post @form.attr('action'), @form.serialize(), =>
      @form.get(0).reset()
      props =
        marginTop: (-@widget.outerHeight() -30 -@vh) + "px"
      props_success =
        marginTop: '0'
      options =
        duration: 500
      options_form =
        duration: 500
        complete: ()=>
          @current = @success

      @widget.velocity("stop").velocity(props, options)
      @success.velocity("stop").velocity(props_success, options_form)


  close: =>
    props =
      marginTop: (-@current.outerHeight() -30 -@vh) + "px"

    options =
      duration: 500

    @current.velocity("stop").velocity(props, options)
    @lightbox.velocity("stop").velocity("fadeOut", options)

  open: =>
    props =
      marginTop: 0
    options =
      duration: 500

    options_form =
      duration: 500
      complete: ()=>
        @current = @widget

    @widget.velocity("stop").velocity(props, options_form)
    @lightbox.velocity("stop").velocity("fadeIn", options)

  fix: (event)=>
    input = $ event.currentTarget
    if input.val().trim() != ""
      input.attr('data-changed', true)
    else
      input.get(0).removeAttr 'data-changed'

$(document).ready ->
  popup = new Popup
  popup.open()
