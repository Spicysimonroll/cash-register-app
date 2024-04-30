require_relative '../../lib/models/discount'
require_relative '../../lib/models/percentage_discount'

describe 'PercentageDiscount' do
  let(:percentage_discount) { PercentageDiscount.new('Buy 3 and pay 2/3 of the original price', 0, (1 / 3.0), 3) }

  it 'should be a class' do
    expect(Object.const_defined?('PercentageDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(PercentageDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "percentage_discount: #{percentage_discount.inspect}"
  end
end
