require_relative '../../lib/repositories/cash_register'
require_relative '../support/helper'

describe 'CashRegister' do
  let(:inventory_csv) { 'spec/support/inventory.csv' }
  let(:cart1_csv) { 'spec/support/cart1.csv' }
  let(:cart2_csv) { 'spec/support/cart2.csv' }
  let(:cart3_csv) { 'spec/support/cart3.csv' }
  let(:inventory_with_headers) do
    [
      ['code', 'product name', 'price(€)'],
      ['GR1', 'Green Tea', 3.11],
      ['SR1', 'Strawberries', 5.00],
      ['CF1', 'Coffee', 11.23]
    ]
  end
  let(:cart1_with_headers) do
    [
      ['quantity', 'product'],
      [2, 'GR1']
    ]
  end
  let(:cart2_with_headers) do
    [
      ['quantity', 'product'],
      [3, 'SR1'],
      [1, 'GR1']
    ]
  end
  let(:cart3_with_headers) do
    [
      ['quantity', 'product'],
      [1, 'GR1'],
      [3, 'CF1'],
      [1, 'SR1']
    ]
  end

  before do
    Helper.write_csv(inventory_csv, inventory_with_headers)
    Helper.write_csv(cart1_csv, cart1_with_headers)
    @cash_register = CashRegister.new(inventory_csv, cart1_csv)
  end

  it 'should be a class' do
    expect(Object.const_defined?('CashRegister')).to be(true)
  end

  it 'should generate test data' do
    puts "inventory_csv: #{inventory_csv.inspect}"
    puts "cart1_csv: #{cart1_csv.inspect}"
    puts "cart2_csv: #{cart2_csv.inspect}"
    puts "cart3_csv: #{cart3_csv.inspect}"
    puts "inventory_with_headers: #{inventory_with_headers.inspect}"
    puts "cart1_with_headers: #{cart1_with_headers.inspect}"
    puts "cart2_with_headers: #{cart2_with_headers.inspect}"
    puts "cart3_with_headers: #{cart3_with_headers.inspect}"
    puts "@cash_register: #{@cash_register.inspect}"
  end
end
