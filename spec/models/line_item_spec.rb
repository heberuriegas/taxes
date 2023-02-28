# frozen_string_literal: true

require './spec/spec_helper'
require './models/line_item'

RSpec.describe Models::LineItem, type: :model do
  subject { build(:line_item) }

  it '#amount' do
    result = ((subject.quantity * subject.price) + subject.taxes).round(2)
    expect(subject.amount).to eq(result)
  end

  it '#taxes' do
    allow(Services::TaxCalculator).to receive(:perform).and_return(10)
    expect(subject.taxes).to eq(subject.quantity * 10)
  end
end
