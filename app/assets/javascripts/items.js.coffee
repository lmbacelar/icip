jQuery ->
  # vars
  selecting = false
  x=[]
  y=[]
  # helper functions
  sortNumbers = (a,b) -> a-b
  imageX = (image, e) -> e.pageX - $(image).offset().left
  imageY = (image, e) -> e.pageY - $(image).offset().top
  setXY = (index, pos_x, pos_y) ->
    x[index-1] = pos_x
    y[index-1] = pos_y
    $("#item_location_attributes_x" + index).val(pos_x)
    $("#item_location_attributes_y" + index).val(pos_y)
  startSelect = (image) ->
    selecting = true
    setXY(1, '','') && setXY(2, '','')
    $('#item_location_attributes_image_id').val($(image).attr('id'))
  stopSelect = ->
    selecting = false
    x.sort(sortNumbers) && y.sort(sortNumbers)
    setXY(1, x[0], y[0]) && setXY(2, x[1], y[1])

  # On load
  $('.item_location_form').hide()
  $('.item_location_helper').show()

  # bound mouse events on ac_locator
  $('.item_locator').mousedown (e)-> startSelect(@) && setXY(1, imageX(@, e), imageY(@, e)) && false
  # TODO: Show box on item location ====> setXY && drawBox is selecting
  $('.item_locator').mousemove (e)-> setXY(2, imageX(@, e), imageY(@, e)) if selecting
  $('.item_locator').mouseleave (e)-> setXY(2, imageX(@, e), imageY(@, e)) && stopSelect() if selecting
  $('.item_locator').mouseup (e)-> setXY(2, imageX(@, e), imageY(@, e)) && stopSelect() if selecting

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
