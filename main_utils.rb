# frozen_string_literal: true

require './app/models/line_item'

# Utils for main program
# :reek:UtilityFunction
class MainUtils
  class << self
    def extract_quantity(line)
      line.split[0]
    end

    def extract_name(line)
      line.split[1..-3].join(' ')
    end

    def extract_price(line)
      line.split[-1]
    end

    def generate_line_item(line)
      quantity = extract_quantity(line)
      name = extract_name(line)
      price = extract_price(line)

      Models::LineItem.new(quantity: quantity.to_i, name: name, price: price.to_f)
    end
  end
end
