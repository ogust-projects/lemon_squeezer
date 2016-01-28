module LemonSqueezer
  class Wallet
    attr_accessor :id, :lwid, :balance, :name, :first_name, :last_name, :email, :iban, :status, :blocked, :error

    GET_DETAILS_PARAMS = %i(wallet email)
    REGISTER_PARAMS    = %i(wallet clientMail clientFirstName clientLastName)

    def initialize(params = {})
      @id         = params[:id]
      @email      = params[:email]
      @first_name = params[:first_name]
      @last_name  = params[:last_name]
    end

    def get_details
      request = Request.new(GET_DETAILS_PARAMS, get_details_params, get_details_message, :get_wallet_details, :wallet)

      Response.new(request).submit do |result, error|
        if result
          self.id      = result[:id]
          self.balance = result[:bal].to_f
          self.name    = result[:name]
          self.email   = result[:email]
          self.iban    = []
          self.status  = result[:status].to_i
          self.blocked = result[:blocked] == '1'
        end

        self.error = error
      end

      self
    end

    def register
      request = Request.new(REGISTER_PARAMS, register_params, register_message, :register_wallet, :wallet)

      Response.new(request).submit do |result, error|
        if result
          self.id   = result[:id]
          self.lwid = result[:lwid]
        end

        self.error = error
      end

      self
    end

    private

    def get_details_params
      params = {}

      params.merge!(wallet: self.id) if self.id
      params.merge!(email: self.email) if self.email

      params
    end

    def get_details_message
      message = get_details_params.merge!(
                  version: '1.7'
                )

      message
    end

    def register_params
      params = {}

      params.merge!(wallet: self.id) if self.id
      params.merge!(clientMail: self.email) if self.email
      params.merge!(clientFirstName: self.first_name) if self.first_name
      params.merge!(clientLastName: self.last_name) if self.last_name

      params
    end

    def register_message
      message = register_params.merge!(
                  version: '1.7'
                )

      message
    end
  end
end
