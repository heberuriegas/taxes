# frozen_string_literal: true

module Services
  # Generate a receipt for a set of line items
  class TotalAmountCalculator
    attr_reader :line_items

    # @param line_items [LineItem[]]
    def initialize(line_items = [])
      @line_items = line_items
    end

    class << self
      # Create a service instance
      # @param name [String]
      # @param price [Decimal]
      def perform(line_items)
        new(line_items).send(:calculate_amounts)
      end
    end

    private

    # Calculate the sum of total and taxes for a list of line items
    def calculate_amounts
      {
        total: line_items.sum(&:amount),
        taxes: line_items.sum(&:taxes)
      }
    end
  end
end
