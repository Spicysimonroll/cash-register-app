class PercentageDiscount < Discount
  def initialize(description:, products_on_promo:, percentage:, threshold:)
    super(description: description, products_on_promo: products_on_promo)
    @percentage = percentage
    @threshold = threshold
  end

  def apply(products:)
    total_quantity = products.sum { |_, v| v[:quantity] }
    tot = 0
    products.each_value do |hash|
      quantity = hash[:quantity]
      price = hash[:product].price
      tot += total_quantity >= @threshold ? quantity * ((price * 100) * @percentage / 100) : 0
    end
    tot.round(2)
  end
end
