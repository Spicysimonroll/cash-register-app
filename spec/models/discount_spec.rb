require_relative '../../lib/models/discount'

describe 'Discount' do
  let(:discount) { Discount.new('€5 discount', 5) }

  it 'should be a class' do
    expect(Object.const_defined?('Discount')).to be(true)
  end

  it 'should generate test data' do
    puts "discount: #{discount.inspect}"
  end
end
