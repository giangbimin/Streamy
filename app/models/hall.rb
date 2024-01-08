# frozen_string_literal: true

class Hall < ApplicationRecord
  has_many :events, dependent: :destroy_async
end
