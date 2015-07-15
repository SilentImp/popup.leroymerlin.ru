class Popup
  constructor: ->
    @widget = $ '.popup.popup_form'
    if @widget.length == 0
      return

    @success = $ '.popup.popup_success'

    console.log 'init'
    @lightbox = $ '.popup__lightbox'
    $('.popup__close, .popup__submit_close').on 'click', @close
    $('.popup__input').on 'change', @fix

    @widget.on 'submit', @showSuccess

  showSuccess: (event)=>
    event.preventDefault()
    props =
      marginTop: '-100vh'
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
      marginTop: '-100vh'

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
