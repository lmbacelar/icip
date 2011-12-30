jQuery ->
  $('#checkpoint_part_number').autocomplete
    minLength: 3,
    source: $('#checkpoint_part_number').data('autocomplete-source')

