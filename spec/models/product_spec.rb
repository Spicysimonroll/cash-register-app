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
end
