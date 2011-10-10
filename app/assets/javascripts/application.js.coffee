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
