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
end
