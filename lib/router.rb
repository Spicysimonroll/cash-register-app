class Router
  def initialize(controller)
    @controller = controller
    @running = true
  end

  def run
    puts 'Welcome to the Cash Register!'
    while @running
      display_options
      puts ''
      action = gets.chomp.to_i
      route_action(action)
    end
  end

  private

  def display_options
    puts ''
    @controller.display_cart_products
    puts ''
    puts 'What do you want to do next?'
    puts ''
    puts '1 - Add a product to the cart'
    puts '2 - Remove a product from the cart'
    puts '3 - Checkout cart'
    puts '4 - Stop and exit the program'
  end

  def route_action(action)
    case action
    when 1 then @controller.add_product_to_cart
    when 2 then @controller.remove_product_from_cart
    when 3 then @controller.checkout
    when 4 then stop
    else
      puts 'Please choose a number between 1-4'
    end
  end

  def stop
    @running = false
  end
end
