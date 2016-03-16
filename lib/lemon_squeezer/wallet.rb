module LemonSqueezer
  class Wallet
    attr_accessor :id, :lwid, :balance, :name, :first_name, :last_name, :email, :iban, :status, :blocked, :error, :is_company, :company_name, :new_status, :technical

    GET_DETAILS_PARAMS   = %i(wallet email)
    REGISTER_PARAMS      = %i(wallet clientMail clientFirstName clientLastName)
    UPDATE_STATUS_PARAMS = %i(wallet newStatus)

    def initialize(params = {})
      @id           = params[:id]
      @email        = params[:email]
      @first_name   = params[:first_name]
      @last_name    = params[:last_name]
      @is_company   = params[:is_company]
      @company_name = params[:company_name]
      @new_status   = params[:new_status]
      @technical    = params[:technical]
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

    def update_status
      request = Request.new(UPDATE_STATUS_PARAMS, update_status_params, update_status_message, :update_wallet_status, :wallet)

      Response.new(request).submit do |result, error|
        if result
          self.id   = result[:id]
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

      message.merge!(isCompany: self.is_company) if self.is_company
      message.merge!(companyName: self.company_name) if self.company_name
      message.merge!(isOneTimeCustomer: self.technical) if self.technical

      message
    end

    def update_status_params
      params = {}

      params.merge!(wallet: self.id) if self.id
      params.merge!(newStatus: self.new_status) if self.new_status

      params
    end

    def update_status_message
      message = update_status_params.merge!(
                  version: '1.0'
                )

      message
    end
  end
end
