class EventsController < ApplicationController
  load_and_authorize_resource only: [:show, :edit, :update, :new, :create, :destroy]

  def index
    @events = Event.filter(params.slice(:name_starts_with, :name_contains))
  end

  def filtered
    @events = Event.filter(params.slice(:search))
    respond_to do |format|
      format.js { render 'shared/search_complete.js.erb' }
    end
  end

  def show
  end

  def edit
  end

  def new
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

  def refresh_follow
    render partial: "follow_button"
  end

  private

    def event_params
      params.require(:event).permit(:name, :starts_at, :ends_at, :description, :user_id, :tag_list)
    end

    
end
