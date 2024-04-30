class BulkPurchaseDiscount < Discount
  def initialize(name, amount, new_price, threshold)
    super(name, amount)
    @discounted_price = new_price
    @threshold = threshold
  end
end
