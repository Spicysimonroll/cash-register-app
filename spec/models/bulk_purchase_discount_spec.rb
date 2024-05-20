require_relative '../../lib/models/discount'
require_relative '../../lib/models/bulk_purchase_discount'
require_relative '../../lib/models/product'

describe 'BulkPurchaseDiscount' do
  let(:bulk_purchase_discount) {
    BulkPurchaseDiscount.new(
      description: 'Buy 3 and pay €4.5 each',
      products_on_promo: [:SR1],
      new_price: 4.5,
      threshold: 3
    )
  }
  let(:coffee) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  it 'should be a class' do
    expect(Object.const_defined?('BulkPurchaseDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(BulkPurchaseDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "bulk_purchase_discount: #{bulk_purchase_discount.inspect}"
    puts "coffee: #{coffee.inspect}"
  end

  describe '#initialize' do
    it 'should take three keyword arguments' do
      parameters = [%i[keyreq description], %i[keyreq products_on_promo], %i[keyreq new_price], %i[keyreq threshold]]

      expect(BulkPurchaseDiscount.instance_method(:initialize).arity).to eq(1)
      expect(BulkPurchaseDiscount.instance_method(:initialize).parameters).to include(*parameters)
      expect(bulk_purchase_discount).to be_a(BulkPurchaseDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} variable" do
        expect(bulk_purchase_discount.instance_variable_defined?(attribute)).to be(true)
        expect(bulk_purchase_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@description, String
    include_examples 'attribute initialization', :@products_on_promo, Set
    include_examples 'attribute initialization', :@new_price, Float
    include_examples 'attribute initialization', :@threshold, Integer
  end

  describe '#apply' do
    it 'should take a keyword argument (the products)' do
      expect(bulk_purchase_discount).to respond_to(:apply)
      expect(BulkPurchaseDiscount.instance_method(:apply).arity).to eq(1)
      expect(BulkPurchaseDiscount.instance_method(:apply).parameters).to include(%i[keyreq products])
    end

    it 'should return the correct discounted price' do
      expect(bulk_purchase_discount.apply(products: { CF1: { quantity: 1, product: coffee } })).to eq(0)
      expect(bulk_purchase_discount.apply(products: { CF1: { quantity: 2, product: coffee } })).to eq(0)
      expect(bulk_purchase_discount.apply(products: { CF1: { quantity: 3, product: coffee } })).to eq(20.19)
    end
  end
end
