# frozen_string_literal: true

require './spec/spec_helper'
require './services/total_amount_calculator'

RSpec.describe Services::TotalAmountCalculator, type: :service do
  subject { Services::TotalAmountCalculator }

  context 'successfully' do
    before(:each) do
      @line_items = build_list(:line_item, rand(5..10))
      @amounts = subject.perform(@line_items)
    end

    # TODO: stub Services::LineItemTaxIdentifier.perform
    it 'calculate total' do
      expect(@amounts[:total]).to eq(@line_items.sum(&:amount))
    end

    it 'calculate taxes' do
      expect(@amounts[:taxes]).to eq(@line_items.sum(&:taxes))
    end
  end
end
