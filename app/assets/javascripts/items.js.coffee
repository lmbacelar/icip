jQuery ->
  # set vars based on form or show values
  if $('#item_location_attributes_x1').length
    x=[$('#item_location_attributes_x1').val(), $('#item_location_attributes_x2').val()]
    y=[$('#item_location_attributes_y1').val(), $('#item_location_attributes_y2').val()]
    imageOffsetX=$("##{$('#item_location_attributes_image_id').val()}").position().top
  else if $('#x1').length
    x=[$('#x1').text(), $('#x2').text()]
    y=[$('#y1').text(), $('#y2').text()]
    imageOffsetX=$("##{$('#image_id').text()}").position().top

  # helper functions
  ##
  # TODO:
  # Share this functions with all js files
  # Now is duplicate on zones.js and items.js
  sortNumbers = (a,b) -> a-b
  drawBox = (offset, x1, y1, x2, y2) ->
    $('.item_location').css('left', "#{x1}px")
    $('.item_location').css('top', "#{y1-0+offset-2}px")
    $('.item_location').css('width', "#{Math.abs(x2-x1-2)}px")
    $('.item_location').css('height', "#{Math.abs(y2-y1-2)}px")

  # show/hide helper on locator hover
  $('.item_locator').hover ->
    $('.item_location_form').toggle()
    $('.item_location_helper').toggle()
  drawBox(imageOffsetX, x[0], y[0], x[1], y[1])

  # selectable events
  $('.item_locator').selectable
    start: (e) ->
      $('.item_location').hide()
      $('#item_location_attributes_image_id').val($(@).attr('id'))
      x[0]=e.pageX - $(@).offset().left
      y[0]=e.pageY - $(@).offset().top
      false
    stop: (e) ->
      x[1]=e.pageX - $(@).offset().left
      y[1]=e.pageY - $(@).offset().top
      imageOffsetX=$(@).position().top
      x.sort(sortNumbers) && y.sort(sortNumbers)
      $('#item_location_attributes_x1').val(x[0])
      $('#item_location_attributes_y1').val(y[0])
      $('#item_location_attributes_x2').val(x[1])
      $('#item_location_attributes_y2').val(y[1])
      drawBox(imageOffsetX, x[0], y[0], x[1], y[1])
      $('.item_location').show()

  # Open Item based on mouse click on AC layout
  #
  # TODO:
  # Find item based on clicked X, Y and X1, Y1, X2, Y2 of the item
  # (X1 <= X <= X2) AND (Y1 <= Y <= Y2)
  # Overlapping? returns more than one result
  $('.ac_layout').click (e)->
    offset = $(@).offset()
    x = e.pageX - offset.left
    y = e.pageY - offset.top
    alert "x = #{x}\ty = #{y}"
