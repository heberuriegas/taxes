# frozen_string_literal: true

require './app/services/line_item_tax_identifier'

module Services
  # Will calculate taxes depending
  class TaxCalculator
    attr_reader :name, :price_in_cents, :line_item_tax_identifier

    # @param name [String]
    # @param price [Decimal]
    def initialize(name, price)
      @name = name

      # It is better work with integers
      @price_in_cents = self.class.decimal_to_cents(price)

      @line_item_tax_identifier = Services::LineItemTaxIdentifier.perform(name)
    end

    class << self
      # Create a service instance
      # @param name [String]
      # @param price [Decimal]
      def perform(name, price)
        new(name, price).send(:calculate_taxes)
      end

      # Convert a decimal price to cents
      # @param price [Float]
      # @return [Integer]
      def decimal_to_cents(price)
        (price * 100).round
      end

      # Will round up tax amount up to 0.05
      # @param tax [Number] The tax amount in
      # @return [Number]
      def round_up(tax)
        mod = tax % 5
        mod.positive? ? tax + 5 - mod : tax
      end
    end

    private

    # Calculate taxes for basic and imported line items
    def calculate_taxes
      basic_taxes + import_taxes
    end

    def can_apply_basic_taxes
      line_item_tax_identifier[:basic_tax]
    end

    def can_apply_import_taxes
      line_item_tax_identifier[:import_tax]
    end

    def basic_taxes
      can_apply_basic_taxes ? self.class.round_up(price_in_cents * 0.1) / 100 : 0
    end

    def import_taxes
      can_apply_import_taxes ? self.class.round_up(price_in_cents * 0.05) / 100 : 0
    end
  end
end
