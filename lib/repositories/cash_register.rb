require 'csv'
require 'set'
require_relative '../models/product'
require_relative '../models/discount'
require_relative '../models/percentage_discount'
require_relative '../models/buy_one_get_one_free_discount'
require_relative '../models/bulk_purchase_discount'

class CashRegister
  attr_reader :inventory, :cart

  def initialize(inventory_csv:, cart_csv:)
    @inventory_csv = inventory_csv
    @cart_csv = cart_csv
    @inventory = {}
    @cart = {}
    @rules = set_rules
    # @next_id = 1
    load_inventory
    load_cart
  end

  def scan(product:, quantity:)
    code = product.code.to_sym
    @cart.keys.include?(code) ? @cart[code][:quantity] += quantity : @cart[code] = { quantity: quantity, product: product }
    save_cart
  end

  def unscan(product:, quantity:)
    code = product.code.to_sym
    @cart[code][:quantity] -= quantity
    @cart.delete_if { |_, v| v[:quantity].zero? }
    save_cart
  end

  def clear_cart
    @cart = {}
    save_cart
  end

  def total_price
    (subtotal - discounts).round(2)
  end

  private

  def load_inventory
    codes = Set.new
    line = 1
    CSV.foreach(@inventory_csv, headers: true) do |row|
      line += 1
      if codes.include?(row[0])
        puts "Line #{line} of `inventory.csv` was not added to the inventory because its code is already in use"
        puts ''
        next
      else
        @inventory[row[0].to_sym] = Product.new(
          code: row[0],
          name: row[1],
          price: row[2]
        )
        codes << row[0]
      end
    end
  end

  def load_cart
    CSV.foreach(@cart_csv, headers: true) do |row|
      code = row[1].to_sym
      quantity = row[0].to_i
      product = @inventory[code]
      @cart[code] = { quantity: quantity, product: product }
    end
  end

  def save_cart
    CSV.open(@cart_csv, 'w') do |csv|
      csv << %w[quantity product_id]
      @cart.each do |key, hash|
        csv << [hash[:quantity], key]
      end
    end
  end

  def subtotal
    @cart.sum { |_, hash| hash[:quantity] * hash[:product].price }
  end

  def set_rules
    {
      1 => BuyOneGetOneFreeDiscount.new(description: 'Buy one and get one free', products_on_promo: [:GR1]),
      2 => BulkPurchaseDiscount.new(
            description: 'Buy 3 or more and pay €4.50 each',
            products_on_promo: [:SR1],
            new_price: 4.5,
            threshold: 3
          ),
      # 3 => PercentageDiscount.new(
      #       description: 'Buy 3 or more and and pay 2/3 of the original price',
      #       products_on_promo: [:CF1],
      #       percentage: (1 / 3.0),
      #       threshold: 3
      #     )
      3 => PercentageDiscount.new(
            description: 'Buy 3 or more coffees of any kind and and pay half of the original price',
            products_on_promo: [:CF1, :DC1],
            percentage: (1 / 2.0),
            threshold: 3
          )
    }
  end

  def discounts
    @rules.sum do |_, rule|
      applicable_products = @cart.select { |key, _| rule.applicable?(product_code: key) }
      rule.apply(products: applicable_products)
    end
  end
end
