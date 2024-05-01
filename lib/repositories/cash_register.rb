require 'csv'
require_relative '../models/product'

class CashRegister
  attr_reader :inventory, :cart

  def initialize(inventory_csv, cart_csv)
    @inventory_csv = inventory_csv
    @cart_csv = cart_csv
    @inventory = []
    @cart = []
    load_inventory
    load_cart
  end

  def scan(product)
    @cart << product.code
    save_cart
  end

  def unscan(product)
    index = @cart.find_index(product.code)
    @cart.delete_at(index)
    save_cart
  end

  private

  def load_inventory
    CSV.foreach(@inventory_csv, headers: true) { |row| @inventory << Product.new({ code: row[0], name: row[1], price: row[2] }) }
  end

  def load_cart
    CSV.foreach(@cart_csv, headers: true) do |row|
      quantity = row[0].to_i
      product_code = row[1]
      quantity.times { @cart << product_code }
    end
  end

  def save_cart
    CSV.open(@cart_csv, 'w') do |csv|
      csv << %w[quantity product]
      @cart.uniq.each do |product_code|
        count = @cart.count(product_code)
        csv << [count, product_code]
      end
    end
  end
end
