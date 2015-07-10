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
//= require_tree .

$(document).on("page:change", function()
{
	$('a')
	.on("ajax:complete", function(e, data, status, xhr)
	{
		//console.log("complete!");
		//$(this).attr({"data-response": status });
	});

	$('#calendar').fullCalendar({
		events: '/events/calendar.json',
        aspectRatio: 2 //height determined from width, width from css
    })
});