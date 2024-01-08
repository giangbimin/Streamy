# frozen_string_literal: true

class User < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :orders, through: :carts
  has_many :cart_items, through: :carts
  has_many :tickets, through: :orders
  has_many :payments, dependent: :destroy
end
