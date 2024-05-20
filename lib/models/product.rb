class Product
  attr_reader :name, :code, :price

  def initialize(code: nil, name: nil, price: nil)
    # @id = id.nil? ? id : id.to_i
    @name = name.nil? ? name : name.to_s
    @code = code.nil? ? code : code.to_s
    @price = price.nil? ? price : price.to_f
  end
end
