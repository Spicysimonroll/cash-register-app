require_relative '../../lib/models/discount'

describe 'Discount' do
  it 'should be a class' do
    expect(Object.const_defined?('Discount')).to be(true)
  end
end
