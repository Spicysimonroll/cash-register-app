require_relative '../../lib/models/discount'
require_relative '../../lib/models/bulk_purchase_discount'

describe 'BulkPurchaseDiscount' do
  let(:bulk_purchase_discount) { BulkPurchaseDiscount.new('Buy 3 and pay €4.5 each', 0, 4.5, 3) }

  it 'should be a class' do
    expect(Object.const_defined?('BulkPurchaseDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(BulkPurchaseDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "bulk_purchase_discount: #{bulk_purchase_discount.inspect}"
  end
end
