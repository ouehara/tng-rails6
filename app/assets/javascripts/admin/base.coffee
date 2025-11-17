# Turbolinks trick
$(document).ready ->
  $(document).on 'click', "tr.clickable-row", (event) ->
    Turbolinks.visit $(this).data("href")
  $(document).on 'click', "th.clickable-header", (event) ->
    Turbolinks.visit $(this).attr("attr-href")

setContentHeight = ->
  # reset height
  $('.right_col').css 'min-height', $(window).height()
  bodyHeight = $('body').height()
  leftColHeight = $('.left_col').eq(1).height() + $('.sidebar-footer').height()
  contentHeight = if bodyHeight < leftColHeight then leftColHeight else bodyHeight
  # normalize content
  contentHeight -= $('.nav_menu').height() + $('footer').height()
  $('.right_col').css 'min-height', contentHeight - 24

# Open current page
$(document).on 'ready page:load turbolinks:load', ->
  # Open child menu
  # $('#sidebar-menu ul:first > li.current-page > ul').slideDown 0, ->
  $('#sidebar-menu ul > li.current-page > ul').slideDown 0, ->
    setContentHeight()

  # Tooltip
  $('[data-toggle="tooltip"]').tooltip("destroy").tooltip();

  $(window).resize()


  # # Crop avatar
  # $ ->
  #   new CropAvatar($('#crop-avatar'))

$(document).on 'ready', ->
  # modal
  $(document).on 'hidden.bs.modal', ->
    $('#ajax-modal .modal-dialog').removeClass 'modal-lg'
  # Accordion
  $(document).on 'click', '.expand', ->
    $(this).next().slideToggle 200
    $expand = $(this).find('>:first-child')
    if $expand.text() == '+'
      $expand.text '-'
    else
      $expand.text '+'

  # Sidebar
  $(document).on 'click', '#sidebar-menu a', (event) ->
    $li = $(this).parent()
    if $li.hasClass('active')
      $li.removeClass 'active'
      $li.removeClass 'current-page'
      $('ul', $li).slideUp ->
    else
      if !$li.parent().hasClass('child_menu')
        $('#sidebar-menu ul > li').removeClass 'current-page'
        $('#sidebar-menu li').removeClass 'active'
        $('#sidebar-menu li ul').slideUp()

      $li.addClass 'active'
      $('ul:first', $li).slideDown ->

    setContentHeight()

  # toggle small or large menu
  $(document).on 'click', '#menu_toggle', ->
    if $('body').hasClass('nav-md')
      $('body').removeClass('nav-md').addClass 'nav-sm'
      $('.left_col').removeClass('scroll-view').removeAttr 'style'
      $('#sidebar-menu').find('li.active').addClass('active-sm').removeClass 'active'
    else
      $('body').removeClass('nav-sm').addClass 'nav-md'
      $('#sidebar-menu').find('li.active-sm').addClass('active').removeClass 'active-sm'
    setContentHeight()

  # recompute content when resizing
  $(window).smartresize ->
    setContentHeight()
# /Sidebar


 #
 # Resize function without multiple trigger
 #
 # Usage:
 # $(window).smartresize(function(){
 #     // code here
 # });

(($, sr) ->
  # debouncing function from John Hann
  # http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/

  debounce = (func, threshold, execAsap) ->
    timeout = undefined

    debounced = ->
      obj = this
      args = arguments

      delayed = ->
        if !execAsap
          func.apply obj, args
        timeout = null
        return

      if timeout
        clearTimeout timeout
      else if execAsap
        func.apply obj, args
      timeout = setTimeout(delayed, threshold or 100)
      return

    debounced

  # smartresize

  jQuery.fn[sr] = (fn) ->
    if fn then @bind('resize', debounce(fn)) else @trigger(sr)

  return
) jQuery, 'smartresize'
