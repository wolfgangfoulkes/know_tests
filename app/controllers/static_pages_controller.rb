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
  		'summary' => 'New Event Title',
  		'description' => 'The description',
  		'location' => 'Location',
 		 'start' => Event.first.starts_at,
 		 'end' => Event.first.ends_at ,
  		'attendees' => [ 	{ "email" => 'bob@example.com' },
  							{ "email" =>'sally@example.com' } ] 
  	}
  	client = Google::APIClient.new
	client.authorization.access_token = current_user.token
	service = client.discovered_api('calendar', 'v3')
	@set_event = client.execute(
						:api_method => service.events.insert,
                        :parameters => {'calendarId' => current_user.email, 'sendNotifications' => true},
                        :body => JSON.dump(@event),
                        :headers => {'Content-Type' => 'application/json'}
                        )
  end
end
