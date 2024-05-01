require_relative '../../lib/views/view'

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
end
