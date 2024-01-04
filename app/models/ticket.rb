# frozen_string_literal: true

class Ticket < ApplicationRecord
  enum type: { general: 0, vip: 1, box: 2, front_pro: 3 }
end
