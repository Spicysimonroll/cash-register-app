require_relative '../lib/router'
require_relative '../lib/controllers/controller'
require_relative '../lib/repositories/cash_register'

describe 'Router' do
  let(:inventory_csv) { 'spec/support/inventory.csv'}
  let(:cart3_csv) { 'spec/support/cart3.csv'}
  let(:cash_register) { CashRegister.new(inventory_csv, cart3_csv) }
  let(:controller) { Controller.new(cash_register) }
  let(:router) { Router.new(controller) }

  it 'should be a class' do
    expect(Object.const_defined?('Router')).to be(true)
  end

  it 'should generate test data' do
    puts "inventory_csv: #{inventory_csv.inspect}"
    puts "cart3_csv: #{cart3_csv.inspect}"
    puts "cash_register: #{cash_register.inspect}"
    puts "controller: #{controller.inspect}"
    puts "router: #{router.inspect}"
  end
end
