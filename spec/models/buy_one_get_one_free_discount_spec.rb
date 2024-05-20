require_relative '../../lib/models/discount'
require_relative '../../lib/models/buy_one_get_one_free_discount'
require_relative '../../lib/models/product'

describe 'BuyOneGetOneFreeDiscount' do
  let(:buy_one_get_one_free_discount) do
    BuyOneGetOneFreeDiscount.new(
      description: 'Buy one and get one for free',
      products_on_promo: [:GR1]
    )
  end
  let(:coffee) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  it 'should be a class' do
    expect(Object.const_defined?('BuyOneGetOneFreeDiscount')).to be(true)
  end

  it 'should be inheriting Discount class' do
    expect(BuyOneGetOneFreeDiscount.superclass).to be(Discount)
  end

  it 'should generate test data' do
    puts "buy_one_get_one_free_discount: #{buy_one_get_one_free_discount.inspect}"
    puts "coffee: #{coffee.inspect}"
  end

  describe '#initialize' do
    it 'should take two keyword arguments' do
      parameters = [%i[keyreq description], %i[keyreq products_on_promo]]

      expect(BuyOneGetOneFreeDiscount.instance_method(:initialize).arity).to eq(1)
      expect(BuyOneGetOneFreeDiscount.instance_method(:initialize).parameters).to include(*parameters)
      expect(buy_one_get_one_free_discount).to be_a(BuyOneGetOneFreeDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} instance variable" do
        expect(buy_one_get_one_free_discount.instance_variable_defined?(attribute)).to be(true)
        expect(buy_one_get_one_free_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@description, String
    include_examples 'attribute initialization', :@products_on_promo, Set
  end

  describe '#apply' do
    it 'should take a keyword argument (the products)' do
      expect(buy_one_get_one_free_discount).to respond_to(:apply)
      expect(BuyOneGetOneFreeDiscount.instance_method(:apply).arity).to eq(1)
      expect(BuyOneGetOneFreeDiscount.instance_method(:apply).parameters).to include(%i[keyreq products])
    end

    it 'should return the correct discounted price' do
      expect(buy_one_get_one_free_discount.apply(products: { CF1: { quantity: 10, product: coffee } })).to eq(56.15)
      expect(buy_one_get_one_free_discount.apply(products: { CF1: { quantity: 1, product: coffee } })).to eq(0)
      expect(buy_one_get_one_free_discount.apply(products: { CF1: { quantity: 5, product: coffee } })).to eq(22.46)
    end
  end
end
