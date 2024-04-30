require_relative '../../lib/models/discount'
require_relative '../../lib/models/bulk_purchase_discount'

describe 'BulkPurchaseDiscount' do
  it 'should be a class' do
    expect(Object.const_defined?('BulkPurchaseDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(BulkPurchaseDiscount.superclass).to be(Discount)
  end
end
