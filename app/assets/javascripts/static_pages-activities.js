// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var parseBool = function(string) {
    switch(string.toLowerCase().trim()){
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case null: return false;
        default: return Boolean(string);
    }
}

/*
	jquery's .data is not visible to css or html
	.attr is
*/
$(document).on("page:change", function()
{
	$("*[data-drop='toggle']").on("click",
		function(e)
		{
			var id = $(this).data("id");
			var $target = $("*[data-id=" + id + "]");
			var state = $target.attr("data-state");
			$target.attr("data-state", !parseBool(state) );
		}
	);
});
