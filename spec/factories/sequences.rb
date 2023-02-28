# frozen_string_literal: true

FactoryBot.define do
  sequence :price do
    rand(10_000) / 100.to_f
  end

  sequence :boolean do
    [false, true].sample
  end

  sequence :quantity do
    rand(1..5)
  end
end
