var nextPageExists = function()
{
  return ( $(more_link).attr("data-scroll-link") != 0 );
};

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
  $(document).trigger("callbacks:reset");
};

var onLoadComplete = function(jqxhr_, textStatus_ )
{
  // console.log(jqxhr_); 
  // console.log(textStatus_);
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
       success: onLoadSuccess,
       complete: onLoadComplete
  });
};

var scrollStart = function()
{
  if (!nextPageExists())
  {
    return;
  }
  else
  {
    $(more_link).attr("data-scroll-link", 1);
  }
  $(window).on("scroll",
    function()
    {
      if ( approachingBottomOfPage() && waitedLongEnoughBetweenPages() )
      {
          nextPage();
      }
    }
  );
}

var scrollStop = function()
{
  $(window).off("scroll");
  $(more_link).attr("data-scroll-link", 2);
}

var scrollOff = function()
{
  scrollStop();
  $(more_link).attr("data-scroll-link", 0);
}

var scrollOn = function()
{
  $(more_link).attr("data-scroll-link", 1);
  scrollStart();
}

/*
  on scrolling in either direction
    if bottom of view is < pixels from bottom of page
    if > min_ms after last execution
    if more_link returns a url
      load the .js.erb script at more_link's url
    else if more_link is clicked
      load the .js.erb script at more_link's url
*/
$(document).on("page:change", function()
{
	content = "[data-scroll-content]";        /* contains content destination (JQ obj) */
	more_link = "[data-scroll-link]";			    /* contains link to "View More" (JQ obj)  */
	min_ms = 500;					   			            /* milliseconds to wait between loading pages */
	pixels = 500; 									          /* pixels above the page's bottom */

	is_loading = false;   							      /* keep from loading two pages at once */
  last_load_at = null;       						    /* when you loaded the last page */
  	/* 
  		failsafe in case the user gets to the bottom
  	 	without infinite scrolling taking affect.
  	 */
     $(more_link).find('a').on("click",
      function(e)
      {
        e.preventDefault();
        nextPage();
      }
    );

     $(document).on("scroll:off", 
      function()
      {
        scrollOff();
      }
    );
    $(document).on("scroll:on", 
      function()
      {
        scrollOn();
      }
    );
    $(document).on("scroll:stop", 
      function()
      {
        scrollStop();
      }
    );
    $(document).on("scroll:start", 
      function()
      {
        scrollStart();
      }
    );

    $(document).trigger("scroll:on");
});