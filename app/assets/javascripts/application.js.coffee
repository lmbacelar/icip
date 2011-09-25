//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

jQuery ->
  # Show / Hide groups
  #
  # TODO:
  # show / hide up / down icon accordingly
  $('.group').children('.title').click ->
    $(@).siblings().toggle('fast')


  # Locate Inspectable on AC layout, by X,Y coordinates of area
  #
  # TODO:
  # Fill X,Y data on edit inspectable form
  # Assure X1, Y1 < X2, Y2 and area is > zero
  lastpoint = 0
  x1 = 0
  x2 = 0
  y1 = 0
  y2 = 0
  $('.inspectable_locator').click (e)->
    offset = $(@).offset()
    lastpoint += 1
    if (lastpoint%2)
      x1 = e.pageX - offset.left
      y1 = e.pageY - offset.top
    else
      x2 = e.pageX - offset.left
      y2 = e.pageY - offset.top
      alert "x1 = #{x1}\ty1 = #{y1}\nx2 = #{x2}\ty2 = #{y2}"

  # Open Inspectable based on mouse click on AC layout
  #
  # TODO:
  # Find inspectable based on clicked X, Y and X1, Y1, X2, Y2 of the inspectable
  # (X1 <= X <= X2) AND (Y1 <= Y <= Y2)
  # Overlapping? returns more than one result
  $('.ac_layout').click (e)->
    offset = $(@).offset()
    x = e.pageX - offset.left
    y = e.pageY - offset.top
    alert "x = #{x}\ty = #{y}"
