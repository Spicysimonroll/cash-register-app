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

  describe '#initialize' do
    it 'should take four arguments' do
      expect(BulkPurchaseDiscount.instance_method(:initialize).arity).to eq(4)
      expect(bulk_purchase_discount).to be_a(BulkPurchaseDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} variable" do
        expect(bulk_purchase_discount.instance_variable_defined?(attribute)).to be(true)
        expect(bulk_purchase_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@amount, Integer
    include_examples 'attribute initialization', :@discounted_price, Float
    include_examples 'attribute initialization', :@threshold, Integer
  end

  describe '#apply' do
    it 'should take two arguments (the original price and the product quantity)' do
      expect(bulk_purchase_discount).to respond_to(:apply)
      expect(BulkPurchaseDiscount.instance_method(:apply).arity).to eq(2)
    end

    it 'should return the correct discounted price' do
      expect(bulk_purchase_discount.apply(9, 10)).to eq(45)
      expect(bulk_purchase_discount.apply(5, 3)).to eq(13.5)
    end
  end
end
