document.observe("dom:loaded", function() {
  var checkBoxes = $$('input.pick');

  checkBoxes.each(function(s){
    Event.observe(s, 'click', function(event) {
      var team = $(this).next('span.team').innerHTML;
      var spread = $(this).next('span.spread').innerHTML;
      if (!$(this).checked && !$(this).adjacent('input.pick')[0].checked) {
        $(this).next('input.set_team').setValue('');
        $(this).next('input.set_spread').setValue('');
      }else{
        $(this).next('input.set_team').setValue(team);
        $(this).next('input.set_spread').setValue(spread);

        if ($(this).adjacent('input.pick')[0].checked=true) {
          $(this).adjacent('input.pick')[0].checked=false;
        }
      }
    });
  });
});
