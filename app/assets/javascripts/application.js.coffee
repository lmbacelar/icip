//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require nested_form

jQuery ->
  # helper functions
  sortNumbers = (a,b) -> a-b

  drawBox = (offset, x1, y1, x2, y2) ->
    $('.item_location').css('left', "#{x1}px")
    $('.item_location').css('top', "#{y1-0+offset-2}px")
    $('.item_location').css('width', "#{Math.abs(x2-x1-2)}px")
    $('.item_location').css('height', "#{Math.abs(y2-y1-2)}px")

  # Show / Hide groups
  # TODO:
  # show / hide up / down icon accordingly
  $('.group').children('.title').click ->
    $(@).siblings().toggle('fast')

