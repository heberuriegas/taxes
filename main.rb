# frozen_string_literal: true

require './main_utils'
require './app/services/total_amount_calculator'

input = []
loop do
  line = gets
  break unless line

  input << line.chomp
end

line_items = input.map { |line| MainUtils.generate_line_item(line) }
amounts = Services::TotalAmountCalculator.perform(line_items)

# Output
line_items.each do |line_item|
  puts format("#{line_item.quantity} #{line_item.name}: %0.2f", line_item.amount)
end
puts format('Sales Taxes: %0.2f', amounts[:taxes])
puts format('Total: %0.2f', amounts[:total])
