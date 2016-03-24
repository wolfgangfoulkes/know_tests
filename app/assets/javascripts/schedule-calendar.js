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

var TIME_SLOT_DURATION = "02:00:00";
var MIN_EVENT_DURATION = "03:00:00";

var linkToDay = function(moment_)
{
	$('#calendar').fullCalendar("gotoDate", moment_.utc() );
	setFCView("agendaDay");
}

var onDayClick = function(date_, jsevent_, view_)
{
	linkToDay(date_);
}

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

var getFCView = function(width)
{
	if (width > 800)
	{
		return "basicWeek"
	}
	else
	{
		return "agendaDay"
	}
}

var setFCView = function(view) 
{
	$('#calendar').fullCalendar('changeView', view);
}

var setFCViewSettings = function(view, element) 
{
	//var start = $('#calendar').fullCalendar('getView').intervalStart;
	//var end = $('#calendar').fullCalendar('getView').intervalEnd;
	// http://momentjs.com/
	//console.log(start.format("MM"), start.format("YY"));
}

var onViewRender = function(view, element) 
{
	$('#calendar').attr('data-fc-view', view.name);
	//resetFCSize();
	setFCViewSettings(view, element);
	setFCTitle(view, element);
	resetFCSize();
}

var onEventRender = function(event_, element_)
{

}

var onDayRender = function(date_, cell_) // only applies to month, basicWeek, and basicDay
{
	cell_.addClass("k-fcday");
}

var transformData = function(event_)
{
	var min_duration = moment.duration(MIN_EVENT_DURATION);
	var longer_than_min = moment(event_.end).isAfter( moment(event_.start).add(min_duration) );
	var classes = "know-fcevent";
	classes += " "
	classes += (event_.is_current_user) ? 'know-cuser' : 'know-user';
	classes += " "
	classes += (longer_than_min) ? '' : 'know-time-min';
	var _event = 
	{
		title: event_.summary,
		start: event_.start,
		end: event_.end,
		url: event_.url,
		className: classes
		//color: (event_.is_current_user) ?  'rgba(100, 100, 120, 0.2)' : 'rgba(100, 0, 0, 0.3)'
		//backgroundColor: (event_.is_current_user) ? 'rgba(0, 0, 0, 0.0)' : 'rgba(100, 0, 0, 0.3)',
		//borderColor: (event_.is_current_user) ? 'rgba(100, 0, 0, 0.3)' : 'rgba(0, 0, 0, 0.0)',
		//textColor: (event_.is_current_user) ? 'rgba(100, 80, 80, 0.3)' : 'white'
		//id:
	}
	return _event;
}

$(document).on("page:change", function()
{
	

	var data = $('#calendar').data();
	$('#calendar').fullCalendar({
			/* callbacks */
			viewRender: onViewRender,
			dayClick: onDayClick,
			eventRender: onEventRender,
			dayRender: onDayRender,
			/***/

			events: '/schedule/list.json',
			eventDataTransform: transformData,
			height: $('#calendar').height(),
			defaultView: 'basicWeek',
			slotDuration: '02:00:00',//'12:00:00',
			slotLabelInterval: '02:00:00',
			allDaySlot: false,
			eventLimitClick: "day",
			

			header: 
			{
				left: "prev",
				center: "agendaDay, basicWeek, month, today",
				right: "next"
			},
			views: 
			{
				month: 
				{
					titleFormat: "MM | YYYY",
					columnFormat: "ddd",
					eventLimit: true
				},
				week: 
				{
					titleFormat: "MM | YYYY",
					columnFormat: "ddd D"
				},
				day: 
				{
					titleFormat: "MM | YYYY",//"M : D :: 'YY",
					columnFormat: "ddd D" //"dddd"
				}
			}
			
	        //aspectRatio: 1.35 //height determined from width, width from css
	});

	/*** onPageChange callbacks ***/
	if (data["date"])
	{
		linkToDay(moment( data["date"] ))
	}

	/*** other callbacks ***/
	$(window).on('resize', function()
	{
		resetFCSize()
	});
});