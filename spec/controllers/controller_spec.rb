require_relative '../../lib/controllers/controller'
require_relative '../../lib/repositories/cash_register'
require_relative '../../lib/models/percentage_discount'
require_relative '../../lib/models/buy_one_get_one_free_discount'
require_relative '../../lib/models/bulk_purchase_discount'
require_relative '../support/helper'

describe 'Controller' do
  let(:inventory_csv) { 'spec/support/inventory.csv' }
  let(:cart3_csv) { 'spec/support/cart3.csv' }
  let(:cash_register) { CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart3_csv) }
  let(:controller) { Controller.new(cash_register) }
  let(:cart3_with_headers) do
    [
      ['quantity', 'product'],
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

  it 'should be a class' do
    expect(Object.const_defined?('Controller')).to be(true)
  end

  it 'should generate test data' do
    puts "inventory_csv: #{inventory_csv.inspect}"
    puts "cart3_csv: #{cart3_csv.inspect}"
    puts "cash_register: #{cash_register.inspect}"
    puts "controller: #{controller.inspect}"
    puts "green_tea_promo: #{green_tea_promo.inspect}"
    puts "strawberry_promo: #{strawberry_promo.inspect}"
    puts "coffee_promo: #{coffee_promo.inspect}"
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
      rules = { 1 => green_tea_promo, 2 => strawberry_promo, 3 => coffee_promo }
      cash_register.instance_variable_set(:@rules, rules)
      allow($stdout).to receive(:puts)

      controller.display_cart_products

      expect($stdout).to have_received(:puts).with(/.*1.*GR1.*/)
      expect($stdout).to have_received(:puts).with(/.*3.*CF1.*/)
      expect($stdout).to have_received(:puts).with(/.*1.*SR1.*/)
      expect($stdout).to have_received(:puts).with(/.*total.*30.57.*/)
    end
  end

  describe '#add_product_to_cart' do
    it 'should not take any argument' do
      expect(controller).to respond_to(:add_product_to_cart)
      expect(Controller.instance_method(:add_product_to_cart).arity).to eq(0)
    end

    context 'with an existing code' do
      it 'displays inventory, asks for code and quantity and adds product to cart' do
        size_before = cash_register.cart.size
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for).and_return(:GR1)
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for_number).and_return(1)
        controller.add_product_to_cart

        expect(cash_register.cart[:GR1][:quantity]).to eq(2)
        expect(cash_register.cart[:CF1][:quantity]).to eq(3)
        expect(cash_register.cart[:SR1][:quantity]).to eq(1)
        expect(cash_register.cart.size).to eq(size_before)

        Helper.write_csv(cart3_csv, cart3_with_headers)
      end
    end

    context 'with a non-existing code' do
      it 'displays inventory, asks for code and quantity and displays an error message' do
        size_before = cash_register.cart.size
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for_number).and_return(:TEST)
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for).and_return(0)
        allow($stdout).to receive(:puts)
        controller.add_product_to_cart

        expect(cash_register.cart[:GR1][:quantity]).to eq(1)
        expect(cash_register.cart[:CF1][:quantity]).to eq(3)
        expect(cash_register.cart[:SR1][:quantity]).to eq(1)
        expect(cash_register.cart.size).to eq(size_before)
        expect($stdout).to have_received(:puts).with(/.*error.*code.*/i)
      end
    end
  end

  describe '#remove_product_from_cart' do
    it 'should not take any argument' do
      expect(controller).to respond_to(:remove_product_from_cart)
      expect(Controller.instance_method(:remove_product_from_cart).arity).to eq(0)
    end

    context 'with an existing code and the correct quantity' do
      it 'displays inventory, asks for code and quantity and remove product from cart' do
        size_before = cash_register.cart.size
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for).and_return(:CF1)
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for_number).and_return(2)
        controller.remove_product_from_cart

        expect(cash_register.cart[:GR1][:quantity]).to eq(1)
        expect(cash_register.cart[:CF1][:quantity]).to eq(1)
        expect(cash_register.cart[:SR1][:quantity]).to eq(1)
        expect(cash_register.cart.size).to eq(size_before)

        Helper.write_csv(cart3_csv, cart3_with_headers)
      end
    end

    context 'with an existing code and the wrong quantity' do
      it 'displays inventory, asks for code and quantity and displays an error message' do
        size_before = cash_register.cart.size
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for).and_return(:GR1)
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for_number).and_return(3)
        allow($stdout).to receive(:puts)
        controller.remove_product_from_cart

        expect(cash_register.cart.size).to eq(size_before)
        expect($stdout).to have_received(:puts).with(/.*error.*quantity.*/i)
      end
    end

    context 'with a non-existing code' do
      it 'displays products in the cart, asks for code and quantity and displays an error message' do
        size_before = cash_register.cart.size
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for).and_return(:TEST)
        allow(controller.instance_variable_get(:@view)).to receive(:ask_for_number).and_return(0)
        allow($stdout).to receive(:puts)
        controller.remove_product_from_cart

        expect(cash_register.cart.size).to eq(size_before)
        expect($stdout).to have_received(:puts).with(/.*error.*code.*/i)
      end
    end
  end

  describe '#checkout' do
    it 'should not take any argument' do
      expect(controller).to respond_to(:checkout)
      expect(Controller.instance_method(:checkout).arity).to eq(0)
    end

    it 'should clear out the cart' do
      allow($stdout).to receive(:puts)
      expect(cash_register.cart).not_to be_empty

      controller.checkout

      expect($stdout).to have_received(:puts).with(/.*check.*out.*cart/i)
      expect(cash_register.cart).to be_empty

      Helper.write_csv(cart3_csv, cart3_with_headers)
    end
  end
end
