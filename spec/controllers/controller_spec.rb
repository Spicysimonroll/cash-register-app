require_relative '../../lib/controllers/controller'
require_relative '../../lib/repositories/cash_register'

describe 'Controller' do
  let(:inventory_csv) { 'spec/support/inventory.csv' }
  let(:cart3_csv) { 'spec/support/cart3.csv' }
  let(:cash_register) { CashRegister.new(inventory_csv, cart3_csv) }
  let(:controller) { Controller.new(cash_register) }
  let(:cart3_with_headers) do
    [
      ['quantity', 'product'],
      [1, 'GR1'],
      [3, 'CF1'],
      [1, 'SR1']
    ]
  end

  it 'should be a class' do
    expect(Object.const_defined?('Controller')).to be(true)
  end

  it 'should generate test data' do
    puts "inventory_csv: #{inventory_csv.inspect}"
    puts "cart3_csv: #{cart3_csv.inspect}"
    puts "cash_register: #{cash_register.inspect}"
    puts "controller: #{controller.inspect}"
  end
end
