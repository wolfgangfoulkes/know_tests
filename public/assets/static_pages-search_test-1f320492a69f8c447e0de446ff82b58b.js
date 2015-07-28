// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("page:change", function()
{
	$('#keywords').autocomplete({
		source: ['angol', 'bowgob', 'fungan'],
		minLength: 2
	});
});
