require_relative '../views/view'

class Controller
  def initialize(cash_register)
    @view = View.new
    @cash_register = cash_register
  end

  def display_cart_products
    @view.display_cart(@cash_register.cart, @cash_register.total_price)
  end

  def add_product_to_cart
    inventory = @cash_register.inventory
    @view.display_inventory(inventory)
    index = @view.ask_for(:add)
    if index > -1 && index < inventory.size
      product = inventory[index]
      @cash_register.scan(product)
    else
      @view.display_message('ERROR! The index provided does not exist')
    end
  end
end
