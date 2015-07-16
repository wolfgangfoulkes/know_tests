class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.filter(params.slice(:name_contains, :time_contains))
  end

  def show
  end

  def edit
    @user = User.find(@event.user_id)
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { redirect_to root_url, notice: @event.errors.full_messages.join(", ") }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event.update(event_params)
    respond_to do |format|
      if @event.save
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { render :show, status: :created, location: @event }
      else
          format.html { render :edit, notice: @event.errors.full_messages.join(", ") }
          format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def refresh_follow
    render partial: "follow_button"
  end

  def add_to_calendar
    @event = Event.find(params[:id])
    @data = 
    {
        'summary' => @event.name,
        'description' => @event.description,
        'location' => 'Somewhere in Nevada',
        'start' => {
          'dateTime' => @event.starts_at.to_s(:iso8601),
          'timeZone' => 'America/Los_Angeles',
        },
        'end' => {
          'dateTime' => @event.ends_at.to_s(:iso8601),
          'timeZone' => 'America/Los_Angeles',
        }
    }

    client = Google::APIClient.new
    token = Token.find_by email: current_user.email
    client.authorization.access_token = token.fresh_token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute!(
      :api_method => service.events.insert,
      :parameters => {'calendarId' => 'primary', 'sendNotifications' => true},
      :body_object => @data,
      :headers => {'Content-Type' => 'application/json'}
      )
    @data = result.data
  end

  def calendar
    @events = current_user.followees(Event) + current_user.events
    respond_to do |format|
      format.json
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :starts_at, :ends_at, :description, :user_id, :tag_list)
    end

    
end
