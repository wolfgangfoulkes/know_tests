// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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
	var data = $('#calendar').data();
	$('#calendar').fullCalendar({
			events: '/schedule/list.json',
			eventDataTransform: transformData,
			height: 'auto'
	        //aspectRatio: 1.35 //height determined from width, width from css
	});

	if (data["date"])
	{
		$('#calendar').fullCalendar("gotoDate", moment( new Date(data["date"]) ) );
	}
});
