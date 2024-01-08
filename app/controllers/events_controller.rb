# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @seat_categories = @event.seat_categories
    @event_seats = @event.event_seats.group_by(&:seat_category_id)
  end
end
