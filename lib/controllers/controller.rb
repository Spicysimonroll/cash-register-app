require_relative '../views/view'

class Controller
  def initialize(cash_register)
    @view = View.new
    @cash_register = cash_register
  end

  def display_cart_products
    @view.display_cart(@cash_register.cart, @cash_register.total_price)
  end
end
