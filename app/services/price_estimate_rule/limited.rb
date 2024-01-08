# frozen_string_literal: true

module PriceEstimateRule
  class Limited < PriceEstimateRule::Base
    RATE = 1.1
    TOTAL_BLOCK = 10

    def initialize(cart_item, unoccupied_count)
      super(cart_item)
      @unoccupied_count = unoccupied_count
    end

    def call
      estimate_price
      cart_item
    end

    private

    def estimate_price
      current_block = ((@unoccupied_count + 1) / TOTAL_BLOCK) + 1
      current_block = TOTAL_BLOCK if current_block > TOTAL_BLOCK
      cart_item.price = (@base_price * (RATE**(current_block - 1))).round(2)
    end
  end
end
