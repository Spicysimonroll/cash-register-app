require_relative '../../lib/models/discount'
require_relative '../../lib/models/buy_one_get_one_free_discount'

describe 'BuyOneGetOneFreeDiscount' do
  let(:buy_one_get_one_free_discount) { BuyOneGetOneFreeDiscount.new('Buy one green tea and get one for free', 0) }

  it 'should be a class' do
    expect(Object.const_defined?('BuyOneGetOneFreeDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(BuyOneGetOneFreeDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "buy_one_get_one_free_discount: #{buy_one_get_one_free_discount.inspect}"
  end
end
