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


/*****
the sel attributes should be more arbitrary
you don't need to use the same function for both
you can use 
data-state
otherwise, do 
data-tog: snd
data-id: 
data-sel: snd
data-sel-id
data-sel-group
*****/


var dropToggle = function(sender_, e_)
{
	var id = $(sender_).data("id");
	var $target = $("*[data-id=" + id + "]");
	var state = $target.attr("data-state");
	$target.attr("data-state", !parseBool(state) );
}

var sel_toggle = function(sender_, e_) 
{

}

var sel_group = function(sender_, e_, callback_)
{
	var $snd = $(sender_);
	var state = $snd.attr("data-sel-state")
	if (state == 'true') { return; }
	
	var index = $snd.attr("data-sel-snd");
	var group = $snd.attr("data-sel-group");
	var $rcv = $("[data-sel-rcv='" + index + "']");

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

$(document).on("page:change", function()
{
	$("[data-lrefresh]").on("ajax:beforeSend", function(e, jqXHR, settings) {
		$("[data-lrefresh]").attr("data-lrefresh", false);
		$(this).attr("data-lrefresh", true);
	});

	setLinkFromCUrl(".nav-bar > a");

	$("[data-sel-snd][data-sel-group]").on("click", function(e)
	{
		sel_group(this, e);
	});

	$("*[data-drop='toggle']").on("click", 
		function(e)
		{
			dropToggle(this, e);
		}
	);
});