# frozen_string_literal: true

require './app/services/tax_calculator'

module Models
  # Represent a line item of a buy
  # :reek:Attribute
  class LineItem
    attr_accessor :quantity, :name, :price, :basic_tax, :import_tax

    def initialize(quantity: nil, name: nil, price: nil, basic_tax: nil, import_tax: nil)
      @quantity = quantity
      @name = name
      @price = price
      @basic_tax = basic_tax
      @import_tax = import_tax
    end

    # Calculate the total amount
    def amount
      ((quantity * price) + taxes).round(2)
    end

    # Calculate the total taxes
    def taxes
      (quantity * Services::TaxCalculator.perform(name, price)).round(2)
    end
  end
end
