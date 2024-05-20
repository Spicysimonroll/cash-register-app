require_relative '../views/view'

class Controller
  def initialize(cash_register)
    @view = View.new
    @cash_register = cash_register
  end

  def display_cart_products
    @view.display_cart(cart: @cash_register.cart, total_price: @cash_register.total_price)
  end

  def add_product_to_cart
    inventory = @cash_register.inventory
    @view.display_inventory(inventory: inventory)
    code = @view.ask_for(:add)
    quantity = @view.ask_for_number(:add)
    if inventory.keys.include?(code)
      @cash_register.scan(product: inventory[code], quantity: quantity)
    else
      @view.display_message('ERROR! The code provided does not exist')
    end
  end

  def remove_product_from_cart
    cart = @cash_register.cart
    cart_inventory = @cash_register.inventory.select { |key, _| cart.keys.include?(key) }
    @view.display_inventory(inventory: cart_inventory)
    code = @view.ask_for(:remove)
    quantity = @view.ask_for_number(:add)
    if cart_inventory.keys.include?(code) && quantity <= cart[code][:quantity]
      @cash_register.unscan(product: cart_inventory[code], quantity: quantity)
    elsif cart_inventory.keys.include?(code) && quantity > cart[code][:quantity]
      @view.display_message('ERROR! You can\'t remove more than the quantity in the cart')
    elsif !cart_inventory.keys.include?(code)
      @view.display_message('ERROR! The code provided does not exist')
    end
  end

  def checkout
    @view.display_message('Checking out the cart...')
    @cash_register.clear_cart
  end
end
