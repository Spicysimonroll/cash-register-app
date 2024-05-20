class BulkPurchaseDiscount < Discount
  def initialize(description:, products_on_promo:, new_price:, threshold:)
    super(description: description, products_on_promo: products_on_promo)
    @new_price = new_price
    @threshold = threshold
  end

  def apply(products:)
    total_quantity = products.sum { |_, v| v[:quantity] }
    tot = 0
    products.each_value do |hash|
      quantity = hash[:quantity]
      price = hash[:product].price
      tot += total_quantity >= @threshold ? quantity * (price - @new_price) : 0
    end
    tot.round(2)
  end
end
