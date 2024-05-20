require_relative '../../lib/models/discount'
require_relative '../../lib/models/percentage_discount'
require_relative '../../lib/models/product'

describe 'PercentageDiscount' do
  let(:percentage_discount) do
    PercentageDiscount.new(
      description: '30% off for 3 or more Coffee',
      products_on_promo: [:CF1],
      percentage: (1 / 3.0),
      threshold: 3
    )
  end
  let(:coffee) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  it 'should be a class' do
    expect(Object.const_defined?('PercentageDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(PercentageDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "percentage_discount: #{percentage_discount.inspect}"
    puts "coffee: #{coffee.inspect}"
  end

  describe '#initialize' do
    it 'should take three keyword arguments' do
      parameters = [%i[keyreq description], %i[keyreq products_on_promo], %i[keyreq percentage], %i[keyreq threshold]]

      expect(PercentageDiscount.instance_method(:initialize).arity).to eq(1)
      expect(PercentageDiscount.instance_method(:initialize).parameters).to include(*parameters)
      expect(percentage_discount).to be_a(PercentageDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} instance variable" do
        expect(percentage_discount.instance_variable_defined?(attribute)).to be(true)
        expect(percentage_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@description, String
    include_examples 'attribute initialization', :@products_on_promo, Set
    include_examples 'attribute initialization', :@percentage, Float
    include_examples 'attribute initialization', :@threshold, Integer
  end

  describe '#apply' do
    it 'should take an argument (the products)' do
      expect(percentage_discount).to respond_to(:apply)
      expect(PercentageDiscount.instance_method(:apply).arity).to eq(1)
      expect(PercentageDiscount.instance_method(:apply).parameters).to include(%i[keyreq products])
    end

    it 'should return the correct values' do
      expect(percentage_discount.apply(products: { CF1: { quantity: 3, product: coffee } })).to eq(11.23)
      expect(percentage_discount.apply(products: { CF1: { quantity: 4, product: coffee } })).to eq(14.97)
      expect(percentage_discount.apply(products: { CF1: { quantity: 1, product: coffee } })).to eq(0)
      expect(percentage_discount.apply(products: { CF1: { quantity: 2, product: coffee } })).to eq(0)
    end
  end
end
