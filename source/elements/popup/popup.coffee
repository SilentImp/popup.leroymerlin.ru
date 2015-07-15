class Popup
  constructor: ->
    @widget = $ '.popup.popup_form'
    if @widget.length == 0
      return

    @resize()

    @success = $ '.popup.popup_success'
    @lightbox = $ '.popup__lightbox'
    $('.popup__close, .popup__submit_close').on 'click', @close
    $('.popup__input').on 'change', @fix
    @widget.on 'submit', @showSuccess

  resize: (event)=>
    @vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    if @widget.outerHeight() > @vh
      @widget.addClass 'popup_scrolable'
    else
      @widget.removeClass 'popup_scrolable'

    # if Modernizr.mq('(max-width: 500px)')
    #   @widget.get(0).removeAttr()
    #   @success.get(0).removeAttr()

  showSuccess: (event)=>
    event.preventDefault()
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
