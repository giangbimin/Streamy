# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy_async
  has_one :order, dependent: :destroy_async
  enum status: { active: 0, checkout: 1, unactive: 2, done: 3 }
end
