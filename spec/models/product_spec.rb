require_relative '../../lib/models/product'

describe 'Product' do
  let(:empty_product) { Product.new }
  let(:product) { Product.new({ code: 'CF1', name: 'Coffee', price: 11.23 }) }

  it 'should be a class' do
    expect(Object.const_defined?('Product')).to be(true)
  end

  it 'should generate test data' do
    puts "empty_product: #{empty_product.inspect}"
    puts "product: #{product.inspect}"
  end

  describe '#initialize' do
    it 'should take one argument or none' do
      expect(Product.instance_method(:initialize).arity).to eq(-1)
      expect(product).to be_a(Product)
      expect(empty_product).to be_a(Product)
    end

    shared_examples 'attribute initialization' do |attribute, product_class|
      it "should initialize the instance with a #{attribute} variable" do
        expect(product.instance_variable_defined?(attribute)).to be(true)
        expect(product.instance_variable_get(attribute)).to be_a(product_class)
        expect(empty_product.instance_variable_get(attribute)).to be_a(NilClass)
      end
    end

    include_examples 'attribute initialization', :@code, String
    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@price, Float
  end
end
