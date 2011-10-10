jQuery ->
  # Initial Show/Hide instruction steps
  reset_steps =
    $('.fill_loc_step_1').show()
    $('.fill_loc_step_2').hide()
    $('.fill_loc_step_3').hide()

  # Locate Inspectable on AC layout, by X,Y coordinates of area
  #
  # TODO:
  # Assure X1, Y1 < X2, Y2 and area is > zero
  lastpoint = 0
  x1 = 0
  x2 = 0
  y1 = 0
  y2 = 0
  $('.item_locator').click (e)->
    offset = $(@).offset()
    lastpoint += 1
    if (lastpoint%2)
      x1 = e.pageX - offset.left
      y1 = e.pageY - offset.top
      $('#item_location_attributes_x1').val(x1)
      $('#item_location_attributes_y1').val(y1)
      $('#item_location_attributes_x2').val('')
      $('#item_location_attributes_y2').val('')
      $('.fill_loc_step_1').fadeOut()
      $('.fill_loc_step_2').fadeIn()
      $('.fill_loc_step_3').fadeOut()
    else
      x2 = e.pageX - offset.left
      y2 = e.pageY - offset.top
      $('#item_location_attributes_x1').val(Math.min(x1,x2))
      $('#item_location_attributes_y1').val(Math.min(y1,y2))
      $('#item_location_attributes_x2').val(Math.max(x1,x2))
      $('#item_location_attributes_y2').val(Math.max(y1,y2))
      $('.fill_loc_step_3').fadeIn()
      $('.fill_loc_step_2').fadeOut()
      $('.fill_loc_step_1').fadeOut()

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
