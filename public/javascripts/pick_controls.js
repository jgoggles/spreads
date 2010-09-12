document.observe("dom:loaded", function() {
  var checkBoxes = $$('input.pick');

  checkBoxes.each(function(s){
    Event.observe(s, 'click', function(event) {
      if ($(this).next('span').hasClassName('away')) {
        var team = 0;
      }else{
        var team = 1;
      }
      var spread = $(this).next('span.spread').innerHTML;
      
      if (!$(this).checked && !$(this).up().adjacent('div.teamLine')[0].down('input.pick').checked) {
        $(this).up().next('input.set_team').setValue('');
        $(this).up().next('input.set_spread').setValue('');
      }else{
        $(this).up().next('input.set_team').setValue(team);
        $(this).up().next('input.set_spread').setValue(spread);

        if ($(this).up().adjacent('div.teamLine')[0].down('input.pick').checked=true) {
          $(this).up().adjacent('div.teamLine')[0].down('input.pick').checked=false;
        }
      }
    });
  });

	var rows = $$('#gameList li');
  for (var i = 0; i < rows.length; i++) {
      rows[i].onmouseover = function() {
          $(this).addClassName('highlight');
      }
      rows[i].onmouseout = function() {
          $(this).removeClassName('highlight');
      }
  }

});
