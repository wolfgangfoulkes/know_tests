// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var getAirports = function(request, response)
{
	var params = {keywords: request.term};
	$.get("/queries/result", 
		params, 
		function(data){ response(data); }, 
		"json");

}

$(document).on("page:change", function()
{
	$('#keywords').autocomplete({
		source: getAirports,
		minLength: 2
	});
});