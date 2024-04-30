require_relative '../../lib/models/product'

describe 'Product' do
  it 'should be a class' do
    expect(Object.const_defined?('Product')).to be(true)
  end
end
