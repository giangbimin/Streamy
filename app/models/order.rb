# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :cart
  has_many :tickets, dependent: :destroy
end
