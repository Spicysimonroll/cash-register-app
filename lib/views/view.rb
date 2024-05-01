class View
  def display_cart(cart, tot = 0)
    if cart.empty?
      puts '+--------------------+'
      puts '| Your cart is empty |'
      puts '+----------+---------+'
    else
      puts '+--------------------+'
      puts '|      Your cart     |'
      puts '+----------+---------+'
      puts '| quantity | product |'
      puts '+--------------------+'
      cart.uniq.each do |product_code|
        count = cart.count(product_code)
        puts "|#{' ' * 4}#{count}#{' ' * (6 - count.to_s.size)}|#{' ' * 3}#{product_code}#{' ' * 3}|"
        puts '+--------------------+'
      end
      puts "| total#{' ' * (11 - tot.to_s.size)}€#{tot}  |"
      puts '+--------------------+'
    end
  end

  def display_inventory(inventory)
    puts ''
    puts 'Here\'s a list of the available products:'
    puts ''
    inventory.each_with_index { |product, index| puts "#{index + 1}. #{product.name} (€#{product.price})" }
  end

  def ask_for(action)
    puts ''
    puts "What's the index of the product you want to #{action} #{action == :add ? 'to' : 'from'} the cart?"
    gets.chomp.to_i - 1
  end

  def display_message(message)
    puts ''
    puts message
  end
end
