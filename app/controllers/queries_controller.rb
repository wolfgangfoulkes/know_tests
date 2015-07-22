class QueriesController < ApplicationController
  def result
  	search = Sunspot.search(Event) do
  		keywords("#{params['keywords']}*")
  	end
  	bucket = search.results.first(5).map{|x| x.name }
  	logger.debug "Log: #{search.results.inspect}"
  	render :json => bucket
  end
end
