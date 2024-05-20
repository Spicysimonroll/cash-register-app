class Discount
  def initialize(description:, products_on_promo:)
    @description = description
    @products_on_promo = Set.new(products_on_promo)
  end

  def applicable?(product_code:)
    @products_on_promo.include?(product_code)
  end

  def apply(products:)
    raise NotImplementedError, "#{self.class} does not implement apply(product) method"
  end
end
