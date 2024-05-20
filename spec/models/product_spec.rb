require_relative '../../lib/models/product'

describe 'Product' do
  let(:empty_product) { Product.new }
  let(:product) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  it 'should be a class' do
    expect(Object.const_defined?('Product')).to be(true)
  end

  it 'should generate test data' do
    puts "empty_product: #{empty_product.inspect}"
    puts "product: #{product.inspect}"
  end

  describe '#initialize' do
    it 'should take three optional arguments' do
      expect(Product.instance_method(:initialize).arity).to eq(-1)
      expect(Product.instance_method(:initialize).parameters).to include(%i[key code], %i[key name], %i[key price])
      expect(product).to be_a(Product)
      expect(empty_product).to be_a(Product)
    end

    shared_examples 'attribute initialization' do |attribute, product_class|
      it "should initialize the instance with a #{attribute} instance variable" do
        expect(product.instance_variable_defined?(attribute)).to be(true)
        expect(product.instance_variable_get(attribute)).to be_a(product_class)
        expect(empty_product.instance_variable_get(attribute)).to be_a(NilClass)
      end
    end

    # include_examples 'attribute initialization', :@id, Integer
    include_examples 'attribute initialization', :@code, String
    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@price, Float
  end

  # describe '#id' do
  #   it 'should allow read-only access' do
  #     expect(product).to respond_to(:id)
  #     expect(product).not_to respond_to(:id=)
  #   end

  #   it 'should return the correct id' do
  #     expect(product.id).to eq(1)
  #     expect(empty_product.id).to eq(nil)
  #   end
  # end

  describe '#code' do
    it 'should allow read-only access' do
      expect(product).to respond_to(:code)
      expect(product).not_to respond_to(:code=)
    end

    it 'should return the correct code' do
      expect(product.code).to eq('CF1')
      expect(empty_product.code).to eq(nil)
    end
  end

  describe '#name' do
    it 'should allow read-only access' do
      expect(product).to respond_to(:name)
      expect(product).not_to respond_to(:name=)
    end

    it 'should return the correct name' do
      expect(product.name).to eq('Coffee')
      expect(empty_product.name).to eq(nil)
    end
  end

  describe '#price' do
    it 'should allow read-only access' do
      expect(product).to respond_to(:price)
      expect(product).not_to respond_to(:price=)
    end

    it 'should return the correct price' do
      expect(product.price).to eq(11.23)
      expect(empty_product.price).to eq(nil)
    end
  end
end
