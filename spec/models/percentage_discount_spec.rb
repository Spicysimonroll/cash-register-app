require_relative '../../lib/models/discount'
require_relative '../../lib/models/percentage_discount'

describe 'PercentageDiscount' do
  it 'should be a class' do
    expect(Object.const_defined?('PercentageDiscount')).to be(true)
  end
end
