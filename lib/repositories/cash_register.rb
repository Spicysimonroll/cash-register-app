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
end
