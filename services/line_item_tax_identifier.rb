# frozen_string_literal: true

require './utils/dictionary'

module Services
  # Identify if a line item is a base tax or imported tax line item
  class LineItemTaxIdentifier
    attr_reader :name

    def initialize(name)
      @name = name
    end

    class << self
      def perform(name)
        new(name).send(:tax_types)
      end

      def basic_tax_dictionary
        Utils::Dictionary::BASIC_TAX_DICTIONARY
      end

      def import_tax_dictionary
        Utils::Dictionary::IMPORT_TAX_DICTIONARY
      end
    end

    private

    # Return the type of taxes applied depending of the line item name
    # @return [Object]
    def tax_types
      {
        basic_tax: basic_taxes,
        import_tax: import_taxes
      }
    end

    def basic_taxes
      Utils::Dictionary::BASIC_TAX_DICTIONARY.none? { |word| name.include? word }
    end

    def import_taxes
      Utils::Dictionary::IMPORT_TAX_DICTIONARY.any? { |word| name.include? word }
    end
  end
end
