/*
	- should query CALENDAR size rather than window size
	then you could set css breakpoints for widths
	and resize the calendar more dynamically
	
	- height should be fixed

	- you don't really need the dynamic view-switching,
	if the option is week. instead, change the default view
	it might only become necessary with device rotation, 
	which you might query elseways
	or just make all mobile sizes default to day
*/

var resetFCSize = function() 
{
	var height = $('#calendar').height();
	$('#calendar').fullCalendar('option', 'height', height);
}

var setFCTitle = function(view, element)
{
	var title = view.title;
	$('#calendar-title').text(title);
}

var onViewRender = function(view, element) 
{
	$('#calendar').attr('data-fc-view', view.name);
	resetFCSize();
	setFCViewSettings(view, element);
	setFCTitle(view, element);
}

var getFCView = function(width)
{
	if (width > 800)
	{
		return "basicWeek"
	}
	else
	{
		return "basicDay"
	}
}

var setFCView = function(view) 
{
	$('#calendar').fullCalendar('changeView', view);
}

var setFCViewSettings = function(view, element) 
{
	var start = $('#calendar').fullCalendar('getView').intervalStart;
	var end = $('#calendar').fullCalendar('getView').intervalEnd;
	// http://momentjs.com/
	//console.log(start.format("MM"), start.format("YY"));
}

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
			viewRender: onViewRender,

			events: '/schedule/list.json',
			eventDataTransform: transformData,
			height: $('#calendar').height(),
			defaultView: 'basicWeek',


			header: 
			{
				left: "prev",
				center: "basicDay, basicWeek, month, today",
				right: "next"
			},
			views: 
			{
				month: 
				{
					titleFormat: "MM | YYYY",
					columnFormat: "ddd"
				},
				week: 
				{
					titleFormat: "MM | YYYY",
					columnFormat: "ddd D"
				},
				day: 
				{
					titleFormat: "MM | YYYY",//"M : D :: 'YY",
					columnFormat: "ddd D"//"dddd"
				}
			}
	        //aspectRatio: 1.35 //height determined from width, width from css
	});

	$(window).on('resize', function()
	{
		resetFCSize()
	});


	if (data["date"])
	{
		$('#calendar').fullCalendar("gotoDate", moment( data["date"] ).utc() );
		setFCView("basicDay");
	}
	else {
		//onWindowResize();
		var width = $(window).width();
		var view = getFCView(width);
		setFCView(view);
	}
});