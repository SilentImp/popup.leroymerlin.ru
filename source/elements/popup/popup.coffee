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
    error = false

    email_regex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
    email_input = @form.find '.popup__input_email'
    email = email_input.val().trim()

    name_input = @form.find '.popup__input_name'
    name = name_input.val().trim()

    console.log email.length
    if email.length == 0
      error = true
      email_input.addClass 'popup__input_error'

    if name.length < 2
      error = true
      name_input.addClass 'popup__input_error'
    else
      name_input.removeClass 'popup__input_error'

    if !email_regex.test(email)
      error = true
      email_input.addClass 'popup__input_error'
      console.log 'error set'
    else
      console.log 'error removed'
      email_input.removeClass 'popup__input_error'

    if error
      return

    $.post(@form.attr('action'), @form.serialize()).complete @onDataSend

  onDataSend: =>
    @form.get(0).reset()
    height = - @widget.outerHeight() - 30 - @vh
    props =
      marginTop: height + "px"
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
    height = - @current.outerHeight() - 30 - @vh
    props =
      marginTop: height + "px"

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
