# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :order
  belongs_to :event_seat
  delegate :user, to: :order
end
