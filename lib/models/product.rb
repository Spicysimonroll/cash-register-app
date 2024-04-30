class Product
  attr_reader :name, :code, :price

  def initialize(attr = {})
    @name = attr.empty? ? nil : attr[:name].to_s
    @code = attr.empty? ? nil : attr[:code].to_s
    @price = attr.empty? ? nil : attr[:price].to_f
  end
end
