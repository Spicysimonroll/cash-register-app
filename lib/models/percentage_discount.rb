class PercentageDiscount < Discount
  def initialize(name, amount, percentage, threshold)
    super(name, amount)
    @percentage = percentage
    @threshold = threshold
  end

  def apply(original_price, product_quantity)
    if product_quantity < @threshold
      product_quantity * original_price
    else
      product_quantity * (((original_price * 100) - ((original_price * 100) * @percentage)) / 100)
    end
  end
end
