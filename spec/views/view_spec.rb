require_relative '../../lib/views/view'
require_relative '../../lib/models/product'

describe 'View' do
  let(:view) { View.new }
  let(:coffee) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }
  let(:green_tea) { Product.new(code: 'GR1', name: 'Green Tea', price: 3.11) }
  let(:strawberry) { Product.new(code: 'SR1', name: 'Strawberry', price: 5.0) }
  let(:inventory) do
    {
      GR1: green_tea,
      SR1: strawberry,
      CF1: coffee
    }
  end
  let(:cart) do
    {
      1 => { quantity: 2, product: green_tea },
      2 => { quantity: 2, product: strawberry },
      3 => { quantity: 1, product: coffee }
    }
  end

  it 'should be a class' do
    expect(Object.const_defined?('View')).to be(true)
  end

  it 'should generate test data' do
    puts "view: #{view.inspect}"
  end

  describe '#display_cart' do
    it 'should take one or two keywords arguments (the cart and the total price)' do
      expect(view).to respond_to(:display_cart)
      expect(View.instance_method(:display_cart).arity).to eq(1)
      expect(View.instance_method(:display_cart).parameters).to include(%i[keyreq cart], %i[key total_price])
    end

    it 'should implement a method to display the products in the cart' do
      allow($stdout).to receive(:puts)
      view.display_cart(cart: cart, total_price: 24.34)

      expect($stdout).to have_received(:puts).with(/.*2.*GR1.*/)
      expect($stdout).to have_received(:puts).with(/.*2.*SR1.*/)
      expect($stdout).to have_received(:puts).with(/.*1.*CF1.*/)
      expect($stdout).to have_received(:puts).with(/.*total.*€24.34.*/)

      empty_cart = []
      view.display_cart(cart: empty_cart)

      expect($stdout).to have_received(:puts).with(/.*cart.*empty.*/i)
    end
  end

  describe '#display_inventory' do
    it 'should take one keyword argument (the inventory)' do
      expect(view).to respond_to(:display_inventory)
      expect(View.instance_method(:display_inventory).arity).to eq(1)
      expect(View.instance_method(:display_inventory).parameters).to include(%i[keyreq inventory])
    end

    it 'should implement a method to display the products in the inventory' do
      allow($stdout).to receive(:puts)
      view.display_inventory(inventory: inventory)

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

    it 'should return a string' do
      allow_any_instance_of(Object).to receive(:gets).and_return('gr1')
      result = view.ask_for(:add)

      allow_any_instance_of(Object).to receive(:gets).and_return('test')
      result2 = view.ask_for(:add)

      expect(result).to eq(:GR1)
      expect(result).to be_a(Symbol)
      expect(result2).to eq(:TEST)
      expect(result2).to be_a(Symbol)
    end
  end

  describe '#ask_for_number' do
    it 'should take one argument (action)' do
      expect(view).to respond_to(:ask_for_number)
      expect(View.instance_method(:ask_for_number).arity).to eq(1)
    end

    it 'should return an integer' do
      allow_any_instance_of(Object).to receive(:gets).and_return("3\n")
      result = view.ask_for_number(:add)

      allow_any_instance_of(Object).to receive(:gets).and_return('test')
      result2 = view.ask_for_number(:remove)

      expect(result).to eq(3)
      expect(result).to be_a(Integer)
      expect(result2).to eq(0)
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
