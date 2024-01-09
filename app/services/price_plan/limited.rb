# frozen_string_literal: true

module PricePlan
  class Limited < PricePlan::Base
    RATE = 1.1
    TOTAL_BLOCK = 10

    def initialize(cart_item, unoccupied_count)
      super(cart_item)
      @unoccupied_count = unoccupied_count
    end

    def call
      current_block = ((@unoccupied_count + 1) / TOTAL_BLOCK) + 1
      current_block = TOTAL_BLOCK if current_block > TOTAL_BLOCK
      (@base_price * (RATE**(current_block - 1))).round(2)
    end
  end
end
