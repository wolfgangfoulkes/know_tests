/*
  prevent_default doesn't work!
*/

var nextPageUrl = function()
{
  return $(more_link).attr("data-scroll-url");
}

var nextPageExists = function()
{
  //return ( $(more_link).attr("data-current") < $(more_link).attr("data-total") );
  return ( $(more_link).attr("data-scroll-url") != 0 );
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

var tryNextPage = function()
{
  if (!nextPageExists() || is_loading)
  {
    return false;
  }

  url = nextPageUrl();
  if (!url)
  {
    return false;
  }
  
  nextPage(url);
}

var nextPage = function(url)
{
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
  $(window).on("scroll",
    function()
    {
      if ( approachingBottomOfPage() && waitedLongEnoughBetweenPages() )
      {
          tryNextPage();
      }
    }
  );
}

var scrollStop = function()
{
  $(window).off("scroll");
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
	content = "[data-scroll-content]";          /* contains content destination (JQ obj) */
	more_link = "[data-scroll-url]";  		      /* contains link to "View More" (JQ obj)  */
  pixels = $(window).height() * 1.1;          /* pixels above the page's bottom */
	min_ms = 500;					   			              /* milliseconds to wait between loading pages */

	is_loading = false;   							        /* keep from loading two pages at once */
  last_load_at = null;      						      /* when you loaded the last page */
  	
    /* 
  		failsafe in case the user gets to the bottom
  	 	without infinite scrolling taking affect.
  	 */
     $(more_link).find('a').on("click",
      function(e)
      {
        e.preventDefault();
        tryNextPage();
      }
    );

    $(document).on("callbacks:reset",
      function()
      {

      }
    );
    $(document).on("scroll:start",
      function()
      {
        if ( !nextPageExists() )
        {
          return;
        }
        scrollStart();
      }
    );
    $(document).on("scroll:stop", 
      function()
      {
        if ( !nextPageExists() )
        {
          return;
        }
        scrollStop();
      }
    );
  
    
    $(document).trigger("scroll:start");
});