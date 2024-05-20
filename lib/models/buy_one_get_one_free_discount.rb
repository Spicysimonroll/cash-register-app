class BuyOneGetOneFreeDiscount < Discount
  def initialize(description:, products_on_promo:)
    super(description: description, products_on_promo: products_on_promo)
  end

  def apply(products:)
    tot = 0
    products.each_value do |hash|
      quantity = hash[:quantity]
      price = hash[:product].price
      tot += (quantity / 2) * price
    end
    tot.round(2)
  end
end
