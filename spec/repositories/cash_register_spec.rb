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

  describe '#initialize' do
    it 'should take two arguments' do
      expect(CashRegister.instance_method(:initialize).arity).to eq(2)
      expect(@cash_register).to be_a(CashRegister)
    end

    it 'should have loaded existing products in inventory.csv' do
      expect(@cash_register).to respond_to(:inventory)
      expect(@cash_register.inventory.size).to eq(inventory_with_headers.size - 1)
      expect(@cash_register.inventory.first).to be_instance_of(Product)

      invalid_product = [['SR1', 'Strawberry Milkshake', 15]]
      Helper.write_csv(inventory_csv, inventory_with_headers + invalid_product)
      new_cash_register = CashRegister.new(inventory_csv, cart1_csv)

      expect(new_cash_register.inventory.size).to eq(@cash_register.inventory.size)
      expect(new_cash_register.inventory.last.name).to eq('Coffee')
    end

    it 'should have loaded existing cart\'s products in cart.csv' do
      expect(@cash_register).to respond_to(:cart)
      expect(@cash_register.cart.size).to eq(2)
      expect(@cash_register.cart.first).to be_a(String)
    end
  end

  describe '#scan' do
    it 'should take an argument (a product to be added to the cart)' do
      expect(@cash_register).to respond_to(:scan)
      expect(CashRegister.instance_method(:scan).arity).to eq(1)
    end

    it 'should add the new product to the cart' do
      size_before = @cash_register.cart.size
      product = @cash_register.inventory.first
      @cash_register.scan(product)

      expect(@cash_register.cart.size).to eq(size_before + 1)
    end
  end

  describe '#unscan' do
    it 'should take an argument (a product to be removed from the cart)' do
      expect(@cash_register).to respond_to(:unscan)
      expect(CashRegister.instance_method(:unscan).arity).to eq(1)
    end

    it 'should remove the new product from the cart' do
      size_before = @cash_register.cart.size
      product = @cash_register.inventory.first
      @cash_register.unscan(product)

      expect(@cash_register.cart.size).to eq(size_before - 1)
    end
  end

  describe '#clear_cart' do
    it 'should not take any argument' do
      expect(@cash_register).to respond_to(:clear_cart)
      expect(CashRegister.instance_method(:clear_cart).arity).to eq(0)
    end

    it 'should clear the cart' do
      @cash_register.clear_cart

      expect(@cash_register.cart).to be_empty
      expect(@cash_register.cart.size).to eq(0)
    end
  end

  describe '#total_price' do
    it 'should not take any argument' do
      expect(@cash_register).to respond_to(:total_price)
      expect(CashRegister.instance_method(:total_price).arity).to eq(0)
    end

    it 'should return the cart correct total price' do
      expect(@cash_register.total_price).to eq(3.11)

      Helper.write_csv(cart2_csv, cart2_with_headers)
      cash_register2 = CashRegister.new(inventory_csv, cart2_csv)

      expect(cash_register2.total_price).to eq(16.61)

      Helper.write_csv(cart3_csv, cart3_with_headers)
      cash_register3 = CashRegister.new(inventory_csv, cart3_csv)

      expect(cash_register3.total_price).to eq(30.57)
    end
  end
end
