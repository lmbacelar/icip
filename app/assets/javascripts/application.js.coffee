//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require globals
//= require nested_form

# Access global objects through Application.
window.Application ||= {}

jQuery ->
  # Show / Hide groups
  # TODO:
  # show / hide up / down icon accordingly
  $('.group').children('.title').click ->
    $(@).siblings().toggle('fast')

