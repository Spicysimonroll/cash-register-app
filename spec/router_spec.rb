require_relative '../lib/router'

describe 'Router' do
  it 'should be a class' do
    expect(Object.const_defined?('Router')).to be(true)
  end
end
