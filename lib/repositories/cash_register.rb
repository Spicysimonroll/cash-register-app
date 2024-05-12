require 'csv'
require_relative '../models/product'
require_relative '../models/discount'
require_relative '../models/percentage_discount'
require_relative '../models/buy_one_get_one_free_discount'
require_relative '../models/bulk_purchase_discount'

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

  def clear_cart
    @cart = []
    save_cart
  end

  def total_price
    tot = 0
    green_tea_promo = BuyOneGetOneFreeDiscount.new('Buy one green tea and get one free', 0)
    strawberry_promo = BulkPurchaseDiscount.new('Buy 3 or more strawberries and pay €4.50 each', 0, 4.5, 3)
    coffee_promo = PercentageDiscount.new('Buy 3 or more coffee and and pay 2/3 of the original price', 0, (1 / 3.0), 3)
    products_in_promo = %w[GR1 SR1 CF1]

    @cart.uniq.each do |product_code|
      product = @inventory.find { |p| p.code == product_code }
      quantity = @cart.count(product_code)
      tot += green_tea_promo.apply(product.price, quantity) if product_code == 'GR1'
      tot += strawberry_promo.apply(product.price, quantity) if product_code == 'SR1'
      tot += coffee_promo.apply(product.price, quantity) if product_code == 'CF1'
      tot += product.price * quantity unless products_in_promo.include?(product_code)
    end

    tot.round(2)
  end

  private

  def load_inventory
    codes = []
    line_number = 1
    CSV.foreach(@inventory_csv, headers: true).with_index do |row, index|
      line_number += 1
      if codes.include?(row[0])
        puts "Line #{line_number} of `inventory.csv` was not added to the inventory because its code is already in use"
        puts ''
        next
      else
        @inventory << Product.new({ code: row[0], name: row[1], price: row[2] })
        codes << row[0]
      end
    end
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
