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

  describe '#initialize' do
    it 'should take two arguments' do
      expect(BuyOneGetOneFreeDiscount.instance_method(:initialize).arity).to eq(2)
      expect(buy_one_get_one_free_discount).to be_a(BuyOneGetOneFreeDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} variable" do
        expect(buy_one_get_one_free_discount.instance_variable_defined?(attribute)).to be(true)
        expect(buy_one_get_one_free_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@amount, Integer
  end

  describe '#apply' do
    it 'should take two arguments (the original price and the quantity)' do
      expect(buy_one_get_one_free_discount).to respond_to(:apply)
      expect(BuyOneGetOneFreeDiscount.instance_method(:apply).arity).to eq(2)
    end

    it 'should return the correct discounted price' do
      expect(buy_one_get_one_free_discount.apply(10, 1)).to eq(10)
      expect(buy_one_get_one_free_discount.apply(10, 2)).to eq(10)
      expect(buy_one_get_one_free_discount.apply(10, 3)).to eq(20)
      expect(buy_one_get_one_free_discount.apply(10, 5)).to eq(30)
    end
  end
end
