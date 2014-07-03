$(document).ready(function() {
	$('.cancel_button').on('click', function() {
		id = $(this).attr('id');
		$.get('/issues/change_status/' + $(this).attr('id') + '.json', function(data) {
			$('#status'+id).html(data.status);
		});
	});
});