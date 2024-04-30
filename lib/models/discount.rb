class Discount
  def initialize(name, amount)
    @name = name
    @amount = amount
  end

  def apply(total_price)
    total_price - @amount
  end
end
