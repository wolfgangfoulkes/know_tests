/*
* --- in static_pages/feed with action static_pages->saved
  <% unless (@events.current_page == @events.total_pages) %>
    <div data-scroll-link="1">
      <%= link_to('View More', url_for(page: @events.current_page + 1)) %>
    </div>  
  <% end %>
*/

var waitedLongEnoughBetweenPages = function()
{
	return ( last_load_at == null || new Date() - last_load_at > min_ms );
};

var approachingBottomOfPage = function()
{
	return ( ( $(window).height() + $(document).scrollTop() ) > ( $(document).height() - pixels ) );

};

var onLoadSuccess = function()
{
	$(more_link).removeClass('loading');
  is_loading = false;
  last_load_at = new Date();
};

var nextPage = function()
{
	url = $(more_link).find('a').attr('href');

  
	if ( is_loading || !url )
  {
    return ( is_loading || !url );
  }

	$(more_link).addClass('loading');
	is_loading = true;
	last_load_at = new Date();

  $.ajax
  ({
       url: url,
       method: 'GET',
       dataType: 'script',
       success: onLoadSuccess
  });
};



$(document).on("page:change", function()
{
	content = "[data-scroll-content]"; 	      /* contains content destination (JQ obj) */
	more_link = "[data-scroll-link]";			    /* contains link to "View More" (JQ obj)  */
	min_ms = 500;									            /* milliseconds to wait between loading pages */
	pixels = 500; 									          /* pixels above the page's bottom */

	is_loading = false;   							      /* keep from loading two pages at once */
  last_load_at = null;       						 /* when you loaded the last page */

  	$(window).scroll(
      function()
    	{    
    		if ( approachingBottomOfPage() && waitedLongEnoughBetweenPages() )
    		{
        		nextPage();
        }
    	}
    );

  	/* 
  		failsafe in case the user gets to the bottom
  	 	without infinite scrolling taking affect.
  	 */
  	$(more_link).find('a').click(
  		function(e)
  		{
    	   nextPage();
    	   e.preventDefault();
    	}
    );

});