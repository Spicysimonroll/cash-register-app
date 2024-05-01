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

  describe '#initialize' do
    it 'should take one argument (the cash register)' do
      expect(Controller.instance_method(:initialize).arity).to eq(1)
      expect(controller).to be_a(Controller)
    end

    shared_examples 'instance variable initialization' do |instance_variable, type|
      it "should initialize the instance with a #{instance_variable} instance variable" do
        expect(controller.instance_variable_defined?(instance_variable)).to be(true)
        expect(controller.instance_variable_get(instance_variable)).to be_a(type)
      end
    end

    include_examples 'instance variable initialization', :@view, View
    include_examples 'instance variable initialization', :@cash_register, CashRegister
  end

  describe '#display_cart_products' do
    it 'should not take any argument' do
      expect(controller).to respond_to(:display_cart_products)
      expect(Controller.instance_method(:display_cart_products).arity).to eq(0)
    end

    it 'should display all the products in the cart' do
      allow($stdout).to receive(:puts)

      controller.display_cart_products

      expect($stdout).to have_received(:puts).with(/.*1.*GR1.*/)
      expect($stdout).to have_received(:puts).with(/.*3.*CF1.*/)
      expect($stdout).to have_received(:puts).with(/.*1.*SR1.*/)
      expect($stdout).to have_received(:puts).with(/.*total.*30.57.*/)
    end
  end
end
