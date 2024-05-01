require_relative '../../lib/views/view'
require_relative '../../lib/models/product'

describe 'View' do
  let(:view) { View.new }

  it 'should be a class' do
    expect(Object.const_defined?('View')).to be(true)
  end

  it 'should generate test data' do
    puts "view: #{view.inspect}"
  end

  describe '#display_cart' do
    it 'should take one or two arguments (the cart and the total price)' do
      expect(view).to respond_to(:display_cart)
      expect(View.instance_method(:display_cart).arity).to eq(-2)
    end

    it 'should implement a method to display the products in the cart' do
      cart = %w[GR1 GR1 SR1 CF1 SR1]
      allow($stdout).to receive(:puts)
      view.display_cart(cart, 24.34)

      expect($stdout).to have_received(:puts).with(/.*2.*GR1.*/)
      expect($stdout).to have_received(:puts).with(/.*2.*SR1.*/)
      expect($stdout).to have_received(:puts).with(/.*1.*CF1.*/)
      expect($stdout).to have_received(:puts).with(/.*total.*€24.34.*/)

      empty_cart = []
      view.display_cart(empty_cart)

      expect($stdout).to have_received(:puts).with(/.*cart.*empty.*/i)
    end
  end

  describe '#display_inventory' do
    it 'should take one argument (the inventory)' do
      expect(view).to respond_to(:display_inventory)
      expect(View.instance_method(:display_inventory).arity).to eq(1)
    end

    it 'should implement a method to display the products in the inventory' do
      coffee = Product.new({ code: 'CF1', name: 'Coffee', price: 11.23 })
      green_tea = Product.new({ code: 'GR1', name: 'Green Tea', price: 3.11 })
      strawberry = Product.new({ code: 'SR1', name: 'Strawberry', price: 5 })
      inventory = [green_tea, strawberry, coffee]

      allow($stdout).to receive(:puts)
      view.display_inventory(inventory)

      expect($stdout).to have_received(:puts).with(/.*Green Tea.*/)
      expect($stdout).to have_received(:puts).with(/.*Coffee.*/)
      expect($stdout).to have_received(:puts).with(/.*Strawberry.*/)
    end
  end

  describe '#ask_for' do
    it 'should take one argument (action)' do
      expect(view).to respond_to(:ask_for)
      expect(View.instance_method(:ask_for).arity).to eq(1)
    end

    it 'should return an index' do
      allow_any_instance_of(Object).to receive(:gets).and_return("2\n")
      result = view.ask_for(:add)

      allow_any_instance_of(Object).to receive(:gets).and_return("test\n")
      result2 = view.ask_for(:add)

      expect(result).to eq(1)
      expect(result).to be_a(Integer)
      expect(result2).to eq(-1)
      expect(result2).to be_a(Integer)
    end
  end

  describe '#display_message' do
    it 'should take one an argument (a message)' do
      expect(view).to respond_to(:display_message)
      expect(View.instance_method(:display_message).arity).to eq(1)
    end

    it 'should display the correct message' do
      allow($stdout).to receive(:puts)

      view.display_message('Hello world')
      view.display_message('This is a test message')

      expect($stdout).to have_received(:puts).with('Hello world')
      expect($stdout).to have_received(:puts).with('This is a test message')
    end
  end
end
