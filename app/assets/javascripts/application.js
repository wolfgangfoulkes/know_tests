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
	page: ""
};

var transformData = function(event_)
{
	var _event = 
	{
		title: event_.summary,
		start: event_.start,
		end: event_.end,
		url: event_.url,
		className: (event_.is_current_user) ? 'know-cue' : 'know-ue',
		//color: (event_.is_current_user) ?  'rgba(100, 100, 120, 0.2)' : 'rgba(100, 0, 0, 0.3)'
		backgroundColor: (event_.is_current_user) ? 'rgba(0, 0, 0, 0.0)' : 'rgba(100, 0, 0, 0.3)',
		borderColor: (event_.is_current_user) ? 'rgba(100, 0, 0, 0.3)' : 'rgba(0, 0, 0, 0.0)',
		textColor: (event_.is_current_user) ? 'rgba(100, 80, 80, 0.3)' : 'white'
		//id:
		//url:
		//className:
	}
	return _event;
}

$(document).on("page:change", function()
{
	KNOW.page = $("body").attr("class");

	$('#calendar').fullCalendar({
		events: '/schedule/list.json',
		eventDataTransform: transformData,
        aspectRatio: 2 //height determined from width, width from css
    })
});