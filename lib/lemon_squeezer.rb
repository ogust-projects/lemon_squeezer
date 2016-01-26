require "savon"
require "ibanizator"
require "net/http"
require "lemon_squeezer/version"
require "lemon_squeezer/request"
require "lemon_squeezer/response"
require "lemon_squeezer/card"
require "lemon_squeezer/iban"
require "lemon_squeezer/transfer"
require "lemon_squeezer/wallet"
require "lemon_squeezer/configuration"

begin
  require "pry"
  require "dotenv"
  Dotenv.load
rescue LoadError
end

module LemonSqueezer
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.card_fast_pay(params = {})
    Card.new(params).fast_pay
  end

  def self.iban_register(params = {})
    Iban.new(params).register
  end

  def self.wallet_get_details(params = {})
    Wallet.new(params).get_details
  end

  def self.wallet_register(params = {})
    Wallet.new(params).register
  end

  def self.transfer_money_out(params = {})
    Transfer.new(params).money_out
  end

  def self.transfer_send_payment(params = {})
    Transfer.new(params).send_payment
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
