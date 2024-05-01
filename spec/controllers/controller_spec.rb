require_relative '../../lib/controllers/controller'

describe 'Controller' do
  it 'should be a class' do
    expect(Object.const_defined?('Controller')).to be(true)
  end
end
