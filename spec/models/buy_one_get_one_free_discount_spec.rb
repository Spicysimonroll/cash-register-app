require_relative '../../lib/models/discount'
require_relative '../../lib/models/buy_one_get_one_free_discount'

describe 'BuyOneGetOneFreeDiscount' do
  it 'should be a class' do
    expect(Object.const_defined?('BuyOneGetOneFreeDiscount')).to be(true)
  end
end
