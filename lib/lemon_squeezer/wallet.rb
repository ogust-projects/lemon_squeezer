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
      if LemonSqueezer::Utils.mandatory_params_present?(GET_DETAILS_PARAMS, get_details_params)
        result  = LemonSqueezer::Request.new(url: 'get_wallet_details', message: get_details_message).response

        if result.has_key?(:wallet)
          wallet       = result[:wallet]
          self.id      = wallet[:id]
          self.balance = wallet[:bal].to_f
          self.name    = wallet[:name]
          self.email   = wallet[:email]
          self.iban    = []
          self.status  = wallet[:status].to_i
          self.blocked = wallet[:blocked] == '1'
        end

        if result.has_key?(:e)
          error      = result[:e]
          self.error =  {
                          code: error[:code].to_i,
                          message: error[:msg]
                        }
        end
      else
        self.error =  {
                        code: -1,
                        message: 'Missing parameters'
                      }
      end

      self
    end

    def get_details_params
      params = {}

      params.merge!(wallet: @id) if @id
      params.merge!(email: @email) if @email

      params
    end

    def get_details_message
      message = get_details_params.merge!(
                  version: '1.7'
                )

      message
    end

    def register
      if LemonSqueezer::Utils.mandatory_params_present?(REGISTER_PARAMS, register_params)
        result  = LemonSqueezer::Request.new(url: 'register_wallet', message: register_message).response

        if result.has_key?(:wallet)
          wallet    = result[:wallet]
          self.id   = wallet[:id]
          self.lwid = wallet[:lwid]
        end

        if result.has_key?(:e)
          error      = result[:e]
          self.error =  {
                          code: error[:code].to_i,
                          message: error[:msg]
                        }
        end
      else
        self.error =  {
                        code: -1,
                        message: 'Missing parameters'
                      }
      end

      self
    end

    def register_params
      params = {}

      params.merge!(wallet: @id) if @id
      params.merge!(clientMail: @email) if @email
      params.merge!(clientFirstName: @first_name) if @first_name
      params.merge!(clientLastName: @last_name) if @last_name

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
