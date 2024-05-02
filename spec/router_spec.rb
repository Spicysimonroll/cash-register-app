require_relative '../lib/router'
require_relative '../lib/controllers/controller'
require_relative '../lib/repositories/cash_register'

describe 'Router' do
  let(:inventory_csv) { 'spec/support/inventory.csv'}
  let(:cart3_csv) { 'spec/support/cart3.csv'}
  let(:cash_register) { CashRegister.new(inventory_csv, cart3_csv) }
  let(:controller) { Controller.new(cash_register) }
  let(:router) { Router.new(controller) }

  it 'should be a class' do
    expect(Object.const_defined?('Router')).to be(true)
  end

  it 'should generate test data' do
    puts "inventory_csv: #{inventory_csv.inspect}"
    puts "cart3_csv: #{cart3_csv.inspect}"
    puts "cash_register: #{cash_register.inspect}"
    puts "controller: #{controller.inspect}"
    puts "router: #{router.inspect}"
  end

  describe '#initialize' do
    it 'should take two arguments' do
      expect(router).to be_a(Router)
      expect(Router.instance_method(:initialize).arity).to eq(1)
    end

    shared_examples 'instance variable initialization' do |instance_variable, type|
      it "should initialize the instance with a #{instance_variable} instance variable" do
        expect(router.instance_variable_defined?(instance_variable)).to be(true)
        expect(router.instance_variable_get(instance_variable)).to be_a(type)
      end
    end

    include_examples 'instance variable initialization', :@controller, Controller
    include_examples 'instance variable initialization', :@running, TrueClass
  end

  describe '#run' do
    it 'should take no arguments' do
      expect(router).to respond_to(:run)
      expect(Router.instance_method(:run).arity).to eq(0)
    end

    context 'when the input is 1' do
      it 'calls :add_product_to_cart on controller' do
        expect(controller).to receive(:add_product_to_cart).once
        expect(controller).not_to receive(:remove_product_from_cart)
        expect(controller).not_to receive(:checkout)
        allow(router).to receive(:gets).and_return("1\n", "4\n")
        allow($stdout).to receive(:puts)
        router.run

        expect($stdout).to have_received(:puts).with(/what do you want to do next?/i).twice
        expect(router.instance_variable_get(:@running)).to be(false)
      end
    end

    context 'when the input is 2' do
      it 'calls :remove_product_from_cart on controller' do
        expect(controller).to receive(:remove_product_from_cart).once
        expect(controller).not_to receive(:add_product_to_cart)
        expect(controller).not_to receive(:checkout)
        allow($stdout).to receive(:puts)
        allow(router).to receive(:gets).and_return("2\n", "4\n")
        router.run

        expect($stdout).to have_received(:puts).with(/what do you want to do next?/i).twice
        expect(router.instance_variable_get(:@running)).to be(false)
      end
    end

    context 'when the input is 3' do
      it 'calls :checkout on controller' do
        expect(controller).to receive(:checkout).once
        expect(controller).not_to receive(:add_product_to_cart)
        expect(controller).not_to receive(:remove_product_from_cart)
        allow(router).to receive(:gets).and_return("3\n", "4\n")
        allow($stdout).to receive(:puts)
        router.run

        expect($stdout).to have_received(:puts).with(/what do you want to do next?/i).twice
        expect(router.instance_variable_get(:@running)).to be(false)
      end
    end

    context 'when input is 4' do
      it 'exits the app' do
        expect(controller).not_to receive(:add_product_to_cart)
        expect(controller).not_to receive(:remove_product_from_cart)
        expect(controller).not_to receive(:checkout)
        allow(router).to receive(:gets).and_return("4\n")
        allow($stdout).to receive(:puts)
        router.run

        expect($stdout).to have_received(:puts).with(/what do you want to do next?/i).once
        expect(router.instance_variable_get(:@running)).to be(false)
      end
    end

    context 'when input is not a number between 1-4' do
      it 'displays an error message' do
        allow(router).to receive(:gets).and_return("-1\n", "4\n")
        allow($stdout).to receive(:puts)
        router.run

        expect($stdout).to have_received(:puts).with(/.*1-4.*/i).once
        expect(router.instance_variable_get(:@running)).to be(false)
      end
    end
  end
end
