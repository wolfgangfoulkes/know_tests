var nextPageUrl = function()
{
  return $(more_link).attr("data-scroll-url");
}

var nextPageExists = function()
{
  url = nextPageUrl();
  return ( url != 0 );
};

var waitedLongEnoughBetweenPages = function()
{
	return ( last_load_at == null || new Date() - last_load_at > min_ms );
};

var approachingBottomOfPage = function()
{
	return ( ( $(window).height() + $(document).scrollTop() ) > ( $(document).height() - pixels ) );
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

var onLoadComplete = function(jqxhr_, textStatus_ )
{
  $(more_link).removeClass('loading');
  is_loading = false;
  // console.log(jqxhr_); 
  // console.log(textStatus_);
};

var onLoadSuccess = function()
{
  $(document).trigger("callbacks:reset");
  last_load_at = new Date();
};

var onLinkClick = function(e) 
{
  e.preventDefault();
  tryNextPage();
}

/* 
  callbacks that respond to page elements that may be changed 
*/
var initPageCallbacks = function()
{
  $(more_link).find('a').on("click", onLinkClick);
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

    $(document).on("callbacks:reset",
      function()
      {
        initPageCallbacks();
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
  
    initPageCallbacks();
    $(document).trigger("scroll:start");
});