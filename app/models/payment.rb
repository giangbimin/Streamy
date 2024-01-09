# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :order
  enum transaction_status: { cancel: 0, paid: 1 }
end
