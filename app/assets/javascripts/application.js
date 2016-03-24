// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require moment
//= require fullcalendar

KNOW = 
{
};

//CALLBACKS = {};

// var initPageAttr()
// {

// }

//var callbacks

var parseBool = function(string) {
    switch(string.toLowerCase().trim()){
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case null: return false;
        default: return Boolean(string);
    }
}

var onComplete = function(jqXHR, status) {
}


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

var $firstOfSels = function(sels_)
{
	for (key in sels_)
	{
		var $sel = $(sels_[key]);
		if ($sel.length > 0)
		{ 
			return $sel; 
		}
	}
	return $();
}
/*
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

var resetCallbacks = function()
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

	resetCallbacks();
	$(document).on("callbacks:reset", 
		function(e)
		{
			resetCallbacks();
		}
	);
});