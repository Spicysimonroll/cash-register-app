require_relative '../../lib/repositories/cash_register'
require_relative '../../lib/models/percentage_discount'
require_relative '../../lib/models/buy_one_get_one_free_discount'
require_relative '../../lib/models/bulk_purchase_discount'
require_relative '../support/helper'


describe 'CashRegister' do
  let(:inventory_csv) { 'spec/support/inventory.csv' }
  let(:cart1_csv) { 'spec/support/cart1.csv' }
  let(:cart2_csv) { 'spec/support/cart2.csv' }
  let(:cart3_csv) { 'spec/support/cart3.csv' }
  let(:inventory_with_headers) do
    [
      ['code', 'product_name', 'price(€)'],
      ['GR1', 'Green Tea', 3.11],
      ['SR1', 'Strawberries', 5.00],
      ['CF1', 'Coffee', 11.23]
    ]
  end
  let(:cart1_with_headers) do
    [
      ['quantity', 'product_code'],
      [2, 'GR1']
    ]
  end
  let(:cart2_with_headers) do
    [
      ['quantity', 'product_code'],
      [3, 'SR1'],
      [1, 'GR1']
    ]
  end
  let(:cart3_with_headers) do
    [
      ['quantity', 'product_code'],
      [1, 'GR1'],
      [3, 'CF1'],
      [1, 'SR1']
    ]
  end
  let(:green_tea_promo) { BuyOneGetOneFreeDiscount.new(description: 'Buy one green tea and get one free', products_on_promo: [:GR1]) }
  let(:strawberry_promo) do
    BulkPurchaseDiscount.new(
      description: 'Buy 3 or more strawberries and pay €4.50 each',
      products_on_promo: [:SR1],
      new_price: 4.5,
      threshold: 3
    )
  end
  let(:coffee_promo) do
    PercentageDiscount.new(
      description: 'Buy 3 or more coffees and and pay 2/3 of the original price',
      products_on_promo: [:CF1],
      percentage: (1 / 3.0),
      threshold: 3
    )
  end

  before do
    Helper.write_csv(inventory_csv, inventory_with_headers)
    Helper.write_csv(cart1_csv, cart1_with_headers)
    @cash_register = CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart1_csv)
    @first = @cash_register.inventory.keys.first
    @last = @cash_register.inventory.keys.last
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
    puts "green_tea_promo: #{green_tea_promo.inspect}"
    puts "strawberry_promo: #{strawberry_promo.inspect}"
    puts "coffee_promo: #{coffee_promo.inspect}"
  end

  describe '#initialize' do
    it 'should take two keyword arguments' do
      parameters = [%i[keyreq inventory_csv], %i[keyreq cart_csv]]

      expect(CashRegister.instance_method(:initialize).arity).to eq(1)
      expect(CashRegister.instance_method(:initialize).parameters).to include(*parameters)
      expect(@cash_register).to be_a(CashRegister)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} instance variable" do
        expect(@cash_register.instance_variable_defined?(attribute)).to be(true)
        expect(@cash_register.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@inventory_csv, String
    include_examples 'attribute initialization', :@cart_csv, String
    include_examples 'attribute initialization', :@inventory, Hash
    include_examples 'attribute initialization', :@cart, Hash
    include_examples 'attribute initialization', :@rules, Hash

    it 'should have loaded existing products in inventory.csv' do
      expect(@cash_register).to respond_to(:inventory)
      expect(@cash_register.instance_variable_get(:@inventory)).to be_a(Hash)
      expect(@cash_register.inventory.keys.size).to eq(inventory_with_headers.size - 1)
      expect(@cash_register.inventory[@first]).to be_instance_of(Product)

      invalid_product = [['SR1', 'Strawberry Milkshake', 15]]
      Helper.write_csv(inventory_csv, inventory_with_headers + invalid_product)
      new_cash_register = CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart1_csv)

      expect(new_cash_register.inventory.size).to eq(@cash_register.inventory.size)
      expect(new_cash_register.inventory[@last].name).to eq('Coffee')
    end

    it 'should have loaded existing cart\'s products in cart.csv' do
      expect(@cash_register).to respond_to(:cart)
      expect(@cash_register.cart.size).to eq(1)

      first = @cash_register.cart.keys.first

      expect(@cash_register.cart[first]).to be_a(Hash)
      expect(@cash_register.cart[first][:quantity]).to be_a(Integer)
      expect(@cash_register.cart[first][:product]).to be_a(Product)
    end
  end

  describe '#scan' do
    it 'should take two keyword arguments (the product and the quantity)' do
      expect(@cash_register).to respond_to(:scan)
      expect(CashRegister.instance_method(:scan).arity).to eq(1)
      expect(CashRegister.instance_method(:scan).parameters).to include(%i[keyreq product], %i[keyreq quantity])
    end

    it 'should add the new product to the cart' do
      hash_size_before = @cash_register.cart.size
      green_tea_quantity_before = @cash_register.cart[@first][:quantity]
      coffee = @cash_register.inventory[@last]
      @cash_register.scan(product: coffee, quantity: 3)
      green_tea = @cash_register.inventory[@first]
      @cash_register.scan(product: green_tea, quantity: 1)

      expect(@cash_register.cart.size).to eq(hash_size_before + 1)
      expect(@cash_register.cart[@first][:quantity]).to eq(green_tea_quantity_before + 1)
      expect(@cash_register.cart[@last][:quantity]).to eq(3)
    end
  end

  describe '#unscan' do
    it 'should take an argument (the product and the quantity)' do
      expect(@cash_register).to respond_to(:unscan)
      expect(CashRegister.instance_method(:unscan).arity).to eq(1)
      expect(CashRegister.instance_method(:unscan).parameters).to include(%i[keyreq product], %i[keyreq quantity])
    end

    it 'should remove the new product from the cart' do
      hash_size_before = @cash_register.cart.size
      green_tea_quantity_before = @cash_register.cart[@first][:quantity]
      green_tea = @cash_register.inventory[@first]
      @cash_register.unscan(product: green_tea, quantity: 1)

      expect(@cash_register.cart.size).to eq(hash_size_before)
      expect(@cash_register.cart[@first][:quantity]).to eq(green_tea_quantity_before - 1)
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

    it 'should return the cart final price' do
      rules = { 1 => green_tea_promo, 2 => strawberry_promo, 3 => coffee_promo }
      @cash_register.instance_variable_set(:@rules, rules)

      expect(@cash_register.total_price).to eq(3.11)

      Helper.write_csv(cart2_csv, cart2_with_headers)
      cash_register2 = CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart2_csv)
      cash_register2.instance_variable_set(:@rules, rules)

      expect(cash_register2.total_price).to eq(16.61)

      Helper.write_csv(cart3_csv, cart3_with_headers)
      cash_register3 = CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart3_csv)
      cash_register3.instance_variable_set(:@rules, rules)

      expect(cash_register3.total_price).to eq(30.57)
    end
  end

  # describe '#rule' do
  #   it 'should take one keyword argument (the rule)' do
  #     expect(@cash_register).to respond_to(:rule)
  #     expect(CashRegister.instance_method(:rule).arity).to eq(1)
  #     expect(CashRegister.instance_method(:rule).parameters).to include(%i[keyreq rule])
  #   end

  #   it 'should add the new rule to the list of existing rules' do
  #     puts @cash_register.instance_variable_get(:@rules).inspect
  #   end
  # end
end
