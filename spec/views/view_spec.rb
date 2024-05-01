require_relative '../../lib/views/view'

describe 'View' do
  it 'should be a class' do
    expect(Object.const_defined?('View')).to be(true)
  end
end
