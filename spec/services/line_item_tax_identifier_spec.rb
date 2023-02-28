# frozen_string_literal: true

require './spec/spec_helper'
require './app/services/line_item_tax_identifier'

# rubocop:disable Metrics/BlockLength
RSpec.describe Services::LineItemTaxIdentifier, type: :service do
  subject { Services::LineItemTaxIdentifier }

  context 'class methods' do
    context 'exent line items' do
      before(:each) do
        @exent_line_item = build(:exent_line_item)
        @service = subject.perform(@exent_line_item.name)
      end

      it 'does not have taxes' do
        expect(@service[:basic_tax]).to eq(false)
        expect(@service[:import_tax]).to eq(false)
      end
    end

    context 'basic line items' do
      before(:each) do
        @basic_line_item = build(:basic_line_item)
        @service = subject.perform(@basic_line_item.name)
      end

      it 'does not have taxes' do
        expect(@service[:basic_tax]).to eq(true)
        expect(@service[:import_tax]).to eq(false)
      end
    end

    context 'import line items' do
      before(:each) do
        @import_line_item = build(:import_line_item)
        @service = subject.perform(@import_line_item.name)
      end

      it 'import_taxes' do
        expect(@service[:basic_tax]).to eq(false)
        expect(@service[:import_tax]).to eq(true)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
