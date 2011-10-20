jQuery ->
  # helper functions
  ##
  # TODO:
  # Share this functions with all js files
  # Now is duplicate on zones.js and items.js
  drawBox = (offset, x1, y1, x2, y2) ->
    $('.item_location').css('left', "#{x1}px")
    $('.item_location').css('top', "#{y1-0+offset-2}px")
    $('.item_location').css('width', "#{Math.abs(x2-x1-2)}px")
    $('.item_location').css('height', "#{Math.abs(y2-y1-2)}px")

  # table hover shows item location
  $('#items_table tr').mouseenter ->
    x=[$(@).children('[name^="x1"]').text(), $(@).children('[name^="x2"]').text()]
    y=[$(@).children('[name^="y1"]').text(), $(@).children('[name^="y2"]').text()]
    imageOffsetX=$("##{$(@).children('[name^="image_id"]').text()}").position().top
    drawBox imageOffsetX, x[0], y[0], x[1], y[1]
    $('.item_location').show()
  $('#items_table tr').mouseleave ->
    $('.item_location').hide()

  $('.item_selector').dblclick (e) ->
    window.location = "#{window.location.href.slice(window.location.href.indexOf('/zones/'))}/items?image_id=#{$(@).attr('id')}&x=#{e.pageX - $(@).offset().left}&y=#{e.pageY - $(@).offset().top}"
