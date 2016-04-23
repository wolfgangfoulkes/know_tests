KNOW = 
{
};

//CALLBACKS = {};

// var initPageAttr()
// {

// }

//var callbacks

var dropToggle = function(sender_, e_)
{
	var id = $(sender_).data("drop-id");
	var $target = $("*[data-drop-id=" + id + "]");
	var state = $target.attr("data-drop-state");
	$target.attr("data-drop-state", !parseBool(state) );
}

var selGroup = function(sender_, e_, callback_)
{
	var $snd = $(sender_);
	var state = $snd.attr("data-sel-state")
	if (state == 'true') { return; }
	
	var index = $snd.attr("data-sel-id");
	var group = $snd.attr("data-sel-group");
	var $rcv = $("[data-sel='rcv'][data-sel-id='" + index + "']");

	$("[data-sel-group='" + group + "'][data-sel-state='true']").attr("data-sel-state", false)
	$snd.attr("data-sel-state", true);
	$rcv.attr("data-sel-state", true);
}

/*
	I DON'T KNOW WHAT FOLLOWING SEZ, BUT THIS SHOULD BE DONE WITH A DATA PARAMETER
	SET BY RUBY IN THE VIEW!

	E.G. when calling the method that generates the link, set the data-state (here, data-current) param based on
	checking url against current page. I THINK THERE IS ACTUALLY A CURRENT_PAGE? method

	future, you'd do this more accurately with an arbitrary helper method
	like current_link("url with *"), then checks against request object 
	using arbitrary Regexp pattern
	then you'd use it to set data-current.
*/
var setLinkFromCUrl = function(sel_)
{
	var c_url = $("body").attr("data-url");
	var sel = sel_ + "[href='" + c_url + "']";
	// api.jquery.com/category/selectors/
	// gonna wanna clip off the query
	$(sel).attr("data-current", true);
}



var setCallbacks = function()
{
	$("[data-sel='snd'][data-sel-group]").off("click");
	$("[data-sel='snd'][data-sel-group]").on("click", 
	function(e)
	{
		selGroup(this, e);
	});
	
	$("*[data-drop='snd']").off("click");
	$("*[data-drop='snd']").on("click", 
	function(e)
	{
		dropToggle(this, e);
	})

}

$(document).on("page:change", function()
{
	// $("[data-lrefresh]").on("ajax:beforeSend", function(e, jqXHR, settings) {
	// 	$("[data-lrefresh]").attr("data-lrefresh", false);
	// 	$(this).attr("data-lrefresh", true);
	// });

	setLinkFromCUrl(".nav-bar > a");

	setCallbacks();
	$(document).on("callbacks:reset", 
		function(e)
		{
			setCallbacks();
		}
	);
});