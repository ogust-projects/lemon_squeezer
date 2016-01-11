require "savon"
require "net/http"
require "lemon_squeezer/version"
require "lemon_squeezer/utils"
require "lemon_squeezer/request"
require "lemon_squeezer/transfert"
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

  def self.wallet_get_details(params = {})
    Wallet.new(params).get_details
  end

  def self.wallet_register(params = {})
    Wallet.new(params).register
  end

  def self.transfert_send_payment(params = {})
    Transfert.new(params).send_payment
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
