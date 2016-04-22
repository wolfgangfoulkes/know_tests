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
    respond_to do |format|
      format.html { @comments = @event.comments.page(1) }
      format.js { 
        @comments = @event.comments.where(role: params[:target]).page(params[:page])
        render 'static_pages/_feed.js.erb', 
        locals: {
          item_partial: "comments/comment",
          items: @comments,
          target: params[:target]
        }
      }
    end
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
