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

	setCallbacks();
	$(document).on("callbacks:reset", 
		function(e)
		{
			setCallbacks();
		}
	);
});