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
	setLinkFromCUrl(".nav-bar > a");
});