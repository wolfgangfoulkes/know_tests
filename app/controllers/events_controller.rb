class EventsController < ApplicationController
  load_and_authorize_resource only: [:show, :edit, :update, :new, :create, :destroy]

  # DON'T PASS USER_ID THROUGH FORM OR ACCEPT IT IN PARAMS
  # CHANGE THAT

  def index # unused, but still useful for tests
    @events = Event.filter(filtering_params)
  end

  def refresh_follow
    render partial: "follow_button"
  end

  def search
    # if params[:target] == "activities"
    #   partial = "static_pages/activity_toggle"
    #   events = Event.where(id: params[:items].split(",")).search(params[:search])
    #   local = :event
    # else
    #   partial = "events/event"
    #   events = Event.where(id: params[:items].split(",")).search(params[:search]).deef
    #   #events = Event.find_by_sql( params[:filter] ).search( params[:search] )
    #   local = :event
    # end
    # respond_to do |format|
    #   format.js { 
    #       render 'shared/events_search.js.erb',
    #       locals:
    #       { 
    #         partial: partial,
    #         collection: events,
    #         local: local
    #       }
    #   }
    # end
    render text: "huh? what?"
  end

  def create
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { redirect_to new_event_path, notice: @event.errors.full_messages.join(", ") }
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

  def show
  end

  def edit
  end

  def new
  end

  private

    def event_params
      params.require(:event).permit(:name, :starts_at, :ends_at, :description, :user_id, :tag_list)
    end

    def filtering_params #unused currently
      params.permit(:starts_after, :order, :search, :name_starts_with, :name_contains)
    end
end
