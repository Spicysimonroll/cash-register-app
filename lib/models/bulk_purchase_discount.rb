class BulkPurchaseDiscount < Discount
  def initialize(name, amount, new_price, threshold)
    super(name, amount)
    @discounted_price = new_price
    @threshold = threshold
  end

  def apply(original_price, product_quantity)
    product_quantity < @threshold ? product_quantity * original_price : product_quantity * @discounted_price
  end
end
