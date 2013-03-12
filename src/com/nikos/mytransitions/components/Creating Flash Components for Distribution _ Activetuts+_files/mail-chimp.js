jQuery(document).ready(function($) {
	$('#mc-signup').submit(function() {
		// update user interface
		$('#mc-response').html('Adding email address...');
		
		// set email address
		var email_adress = escape($('#mc-email').val()),
		    first_name = escape($('#mc-fname').val());
		
		// Prepare query string and send AJAX request
		$.ajax({
			url: mcapi.url,
			data: 'mc-ajax=true&mc-email=' + email_adress + '&mc-fname=' + first_name,
			success: function(msg) {
				$('#mc-response').html(msg);
			}
		});
		return false;
	});
});