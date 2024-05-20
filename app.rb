require_relative 'lib/repositories/cash_register'
require_relative 'lib/controllers/controller'
require_relative 'lib/router'

inventory_csv = File.join(__dir__, 'data/inventory.csv')
cart_csv = File.join(__dir__, 'data/cart.csv')
cash_register = CashRegister.new(inventory_csv: inventory_csv, cart_csv: cart_csv)
controller = Controller.new(cash_register)

router = Router.new(controller)

router.run
