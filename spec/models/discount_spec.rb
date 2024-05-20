require_relative '../../lib/models/discount'

describe 'Discount' do
  let(:discount) { Discount.new(description: 'Test discount', products_on_promo: [:GR1, :CF1]) }

  it 'should be a class' do
    expect(Object.const_defined?('Discount')).to be(true)
  end

  it 'should generate test data' do
    puts "discount: #{discount.inspect}"
  end

  describe '#initialize' do
    it 'should take two keyword arguments' do
      parameters = [%i[keyreq description], %i[keyreq products_on_promo]]

      expect(Discount.instance_method(:initialize).arity).to eq(1)
      expect(Discount.instance_method(:initialize).parameters).to include(*parameters)
      expect(discount).to be_a(Discount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} instance variable" do
        expect(discount.instance_variable_defined?(attribute)).to be(true)
        expect(discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@description, String
    include_examples 'attribute initialization', :@products_on_promo, Set
  end

  describe '#applicable?' do
    it 'should take a keyword argument (a product code)' do
      expect(Discount.instance_method(:applicable?).arity).to eq(1)
      expect(Discount.instance_method(:applicable?).parameters).to include(%i[keyreq product_code])
      expect(discount).to respond_to(:applicable?)
    end

    it 'should return the correct value' do
      expect(discount.applicable?(product_code: :GR1)).to be(true)
      expect(discount.applicable?(product_code: :CF1)).to be(true)
      expect(discount.applicable?(product_code: :SR1)).to be(false)
    end
  end

  describe '#apply' do
    it 'should take an argument (the product)' do
      expect(Discount.instance_method(:apply).arity).to eq(1)
      expect(Discount.instance_method(:apply).parameters).to include(%i[keyreq products])
      expect(discount).to respond_to(:apply)
    end

    it 'should raise NotImplementedError' do
      product = double('Product')

      expect { discount.apply(products: [product]) }.to raise_error(NotImplementedError)
    end
  end
end
