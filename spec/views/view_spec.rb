require_relative '../../lib/views/view'

describe 'View' do
  let(:view) { View.new }

  it 'should be a class' do
    expect(Object.const_defined?('View')).to be(true)
  end

  it 'should generate test data' do
    puts "view: #{view.inspect}"
  end
end
