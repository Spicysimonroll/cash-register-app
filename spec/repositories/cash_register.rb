require_relative '../../lib/repositories/cash_register'

describe 'CashRegister' do
  it 'should be a class' do
    expect(Object.const_defined?('CashRegister')).to be(true)
  end
end
