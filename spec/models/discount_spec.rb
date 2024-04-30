require_relative '../../lib/models/discount'

describe 'Discount' do
  let(:discount) { Discount.new('€5 discount', 5) }

  it 'should be a class' do
    expect(Object.const_defined?('Discount')).to be(true)
  end

  it 'should generate test data' do
    puts "discount: #{discount.inspect}"
  end

  describe '#initialize' do
    it 'should take two arguments' do
      expect(Discount.instance_method(:initialize).arity).to eq(2)
      expect(discount).to be_a(Discount)
    end

    shared_examples 'attribute initialization' do |attribute, type|
      it "should initialize the instance with a #{attribute} variable" do
        expect(discount.instance_variable_defined?(attribute)).to be(true)
        expect(discount.instance_variable_get(attribute)).to be_a(type)
      end
    end

    include_examples 'attribute initialization', :@name, String
    include_examples 'attribute initialization', :@amount, Integer
  end

  describe '#apply' do
    it 'should take an argument (the total price)' do
      expect(discount).to respond_to(:apply)
      expect(Discount.instance_method(:apply).arity).to eq(1)
    end

    it 'should return the correct discounted price' do
      expect(discount.apply(25)).to eq(20)

      other_discount = Discount.new('€15 discount', 15)
      expect(other_discount.apply(45)).to eq(30)
    end
  end
end
