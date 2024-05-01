require_relative '../views/view'

class Controller
  def initialize(cash_register)
    @view = View.new
    @cash_register = cash_register
  end
end
