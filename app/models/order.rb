# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :cart
  has_many :tickets, dependent: :destroy
  enum status: { processing: 0, failed: 1, success: 2 }
end
