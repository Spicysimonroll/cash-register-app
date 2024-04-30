class BuyOneGetOneFreeDiscount < Discount
  def apply(original_price, quantity)
    (quantity % 2).zero? ? (quantity / 2 * original_price) : ((quantity / 2) + 1) * original_price
  end
end
