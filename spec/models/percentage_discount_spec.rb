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

  describe '#initialize' do
    it 'should take four arguments' do
      expect(PercentageDiscount.instance_method(:initialize).arity).to eq(4)
      expect(percentage_discount).to be_a(PercentageDiscount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} variable" do
        expect(percentage_discount.instance_variable_defined?(attribute)).to be(true)
        expect(percentage_discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@amount, Integer
    include_examples 'attribute initialization', :@percentage, Float
    include_examples 'attribute initialization', :@threshold, Integer
  end

  describe '#apply' do
    it 'should take two arguments (the original price and the product quantity)' do
      expect(percentage_discount).to respond_to(:apply)
      expect(PercentageDiscount.instance_method(:apply).arity).to eq(2)
    end

    it 'should return the correct values' do
      expect(percentage_discount.apply(9, 10)).to eq(60)
      expect(percentage_discount.apply(9.9, 10)).to eq(66)
    end
  end
end
