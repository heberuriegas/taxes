# frozen_string_literal: true

require './spec/spec_helper'
require './app/services/tax_calculator'

# rubocop:disable Metrics/BlockLength
RSpec.describe Services::TaxCalculator, type: :service do
  subject { Services::TaxCalculator }

  context 'successfully' do
    context 'for line items' do
      before(:each) do
        @line_item = build(:line_item)
        @name = @line_item.name
        @price_in_cents = subject.decimal_to_cents(@line_item.price)
        @taxes = subject.perform(@line_item.name, @line_item.price)
      end

      # TODO: stub Services::LineItemTaxIdentifier.perform
      it 'apply taxes' do
        tax_types = Services::LineItemTaxIdentifier.perform(@name)

        total = 0
        total += subject.round_up(@price_in_cents * 0.1) / 100 if tax_types[:basic_tax]
        total += subject.round_up(@price_in_cents * 0.05) / 100 if tax_types[:import_tax]

        expect(@taxes).to eq(total)
      end
    end

    context 'for basic line items' do
      before(:each) do
        @line_item = build(:basic_line_item)
        @price_in_cents = subject.decimal_to_cents(@line_item.price)
        @taxes = subject.perform(@line_item.name, @line_item.price)
      end

      it 'apply taxes' do
        expect(@taxes).to eq(subject.round_up(@price_in_cents * 0.1) / 100)
      end
    end

    context 'for import line items' do
      before(:each) do
        @line_item = build(:import_line_item)
        @price_in_cents = subject.decimal_to_cents(@line_item.price)
        @taxes = subject.perform(@line_item.name, @line_item.price)
      end

      it 'apply taxes' do
        expect(@taxes).to eq(subject.round_up(@price_in_cents * 0.05) / 100)
      end
    end
  end

  context 'class methods' do
    before(:each) do
      @line_item = build(:line_item)
    end

    it '#decimal_to_cents' do
      cents = subject.decimal_to_cents(@line_item.price)

      expect(cents).to eq((@line_item.price * 100).round)
    end

    it '#round_up' do
      price_in_cents = subject.decimal_to_cents(@line_item.price)
      rounded = subject.round_up(price_in_cents)

      expect(rounded).to be <= price_in_cents + 5
      expect(rounded % 5).to eq(0)
    end
  end
end
# rubocop:enable Metrics/BlockLength
