class PercentageDiscount < Discount
  def initialize(name, amount, percentage, threshold)
    super(name, amount)
    @percentage = percentage
    @threshold = threshold
  end
end
