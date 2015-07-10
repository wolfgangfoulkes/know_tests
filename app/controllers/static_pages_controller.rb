class StaticPagesController < ApplicationController
  def home
  	@user = current_user
  	@events = Event.all
  	@event = @user.events.build
  end

  def schedule
  	@user = current_user
  	@events = @user.followees(Event)
  end

  def event_test
    	@event = 
    	{
        'summary' => 'Test Event',
      	'description' => 'Testing Event Adding',
      	'location' => 'Somewhere in Nevada',
     		'start' => {
          'dateTime' => '2015-05-28T09:00:00-07:00',
          'timeZone' => 'America/Los_Angeles',
        },
        'end' => {
          'dateTime' => '2015-05-28T17:00:00-07:00',
          'timeZone' => 'America/Los_Angeles',
        }
    	}
      client = Google::APIClient.new
      token = Token.find_by email: current_user.email
      client.authorization.access_token = token.fresh_token
  	  service = client.discovered_api('calendar', 'v3')
      @set_event = client.execute!(
  		:api_method => service.events.insert,
      :parameters => {'calendarId' => 'primary', 'sendNotifications' => true},
      :body => JSON.dump(@event),
      :headers => {'Content-Type' => 'application/json'}
      )
      @event = @set_event.data
  end
end
