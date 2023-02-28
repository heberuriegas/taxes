# frozen_string_literal: true

require 'ffaker'
require './app/models/line_item'
require './app/services/line_item_tax_identifier'
require './app/utils/dictionary'

FactoryBot.define do
  sequence :line_item_name do
    line_item_type_name = ([''] + Utils::Dictionary::BASIC_TAX_DICTIONARY + Utils::Dictionary::IMPORT_TAX_DICTIONARY).sample
    "#{line_item_type_name} #{FFaker::Product.product_name}"
  end

  sequence :basic_line_item_name do
    FFaker::Product.product_name
  end

  sequence :exempt_line_item_name do
    "#{Utils::Dictionary::BASIC_TAX_DICTIONARY.sample} #{FFaker::Product.product_name}"
  end

  sequence :import_line_item_name do
    "#{Utils::Dictionary::IMPORT_TAX_DICTIONARY.sample} #{Utils::Dictionary::BASIC_TAX_DICTIONARY.sample} #{FFaker::Product.product_name}"
  end
end

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :line_item, class: Models::LineItem do
    transient do
      line_item_name { generate(:line_item_name) }
      line_item_basic_tax { Services::LineItemTaxIdentifier.perform(line_item_name)[:basic_tax] }
      line_item_import_tax { Services::LineItemTaxIdentifier.perform(line_item_name)[:import_tax] }
    end

    quantity { generate(:quantity) }
    name { line_item_name }
    price { generate(:price) }
    basic_tax { line_item_basic_tax }
    import_tax { line_item_import_tax }
  end

  factory :basic_line_item, class: Models::LineItem, parent: :line_item do
    name { generate(:basic_line_item_name) }
    basic_tax { true }
    import_tax { false }
  end

  factory :exempt_line_item, class: Models::LineItem, parent: :line_item do
    name { generate(:exempt_line_item_name) }
    basic_tax { false }
    import_tax { false }
  end

  factory :import_line_item, class: Models::LineItem, parent: :line_item do
    name { generate(:import_line_item_name) }
    basic_tax { false }
    import_tax { true }
  end
end
# rubocop:enable Metrics/BlockLength
