class View
  def display_cart(cart:, total_price: 0)
    puts '+--------------------+'
    if cart.empty?
      puts '| Your cart is empty |'
      puts '+----------+---------+'
    else
      puts '|      Your cart     |'
      puts '+----------+---------+'
      puts '| quantity | product |'
      puts '+--------------------+'
      cart.each do |_, hash|
        count = hash[:quantity]
        product_code = hash[:product].code
        puts "|#{' ' * 4}#{count}#{' ' * (6 - count.to_s.size)}|#{' ' * 3}#{product_code}#{' ' * 3}|"
        puts '+--------------------+'
      end
      puts "| total#{' ' * (11 - total_price.to_s.size)}€#{total_price}  |"
      puts '+--------------------+'
    end
  end

  def display_inventory(inventory:)
    puts ''
    puts 'Here\'s a list of the available products:'
    puts ''
    inventory.each do |key, hash|
      puts "#{key} - #{hash.name} (#{hash.price})"
    end
  end

  def ask_for(action)
    puts ''
    puts "What's the code of the product you want to #{action} #{action == :add ? 'to' : 'from'} the cart?"
    gets.chomp.upcase.to_sym
  end

  def ask_for_number(action)
    puts ''
    puts "How many would you like to #{action} #{action == :add ? 'to' : 'from'} the cart?"
    gets.chomp.to_i
  end

  def display_message(message)
    puts ''
    puts message
  end
end
