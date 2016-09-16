module LemonSqueezer
  class Wallet
    attr_accessor :id, :lwid, :balance, :name, :first_name, :last_name, :email, :iban, :status, :blocked, :error,
    :is_company, :company_name, :new_status, :technical, :file_name, :type, :buffer, :country, :document_id

    GET_DETAILS_PARAMS   = %i(wallet email)
    REGISTER_PARAMS      = %i(wallet clientMail clientFirstName clientLastName)
    UPDATE_STATUS_PARAMS = %i(wallet newStatus)
    UPLOAD_FILE_PARAMS   = %i(wallet fileName type buffer)

    FILE_TYPES           = { 'id_card': 0, 'proof_address': 1, 'bank_information': 2, 'company_registration': 7 }

    def initialize(params = {})
      @id           = params[:id]
      @email        = params[:email]
      @first_name   = params[:first_name]
      @last_name    = params[:last_name]
      @country      = params[:country]
      @is_company   = params[:is_company]
      @company_name = params[:company_name]
      @new_status   = params[:new_status]
      @technical    = params[:technical]
      @file_name    = params[:file_name]
      @type         = (FILE_TYPES[params[:type].to_sym].to_s rescue '')
      @buffer       = params[:buffer]
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
        self.id   = result[:id] if result

        self.error = error
      end

      self
    end

    def upload_file
      request = Request.new(UPLOAD_FILE_PARAMS, upload_file_params, upload_file_message, :upload_file, :upload)

      Response.new(request).submit do |result, error|
        self.document_id   = result[:id] if result

        self.error = error
      end

      self
    end

    private

    def get_details_params
      params = {}

      params.merge!(wallet: id) if id
      params.merge!(email: email) if email

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

      params.merge!(wallet: id) if id
      params.merge!(clientMail: email) if email
      params.merge!(clientFirstName: first_name) if first_name
      params.merge!(clientLastName: last_name) if last_name
      params.merge!(isCompany: is_company) if is_company
      params.merge!(ctry: country) if country

      params
    end

    def register_message
      message = register_params.merge!(
                  version: '1.7'
                )

      message.merge!(isCompany: is_company) if is_company
      message.merge!(companyName: company_name) if company_name
      message.merge!(isOneTimeCustomer: technical) if technical

      message
    end

    def update_status_params
      params = {}

      params.merge!(wallet: id) if id
      params.merge!(newStatus: new_status) if new_status

      params
    end

    def update_status_message
      message = update_status_params.merge!(
                  version: '1.0'
                )

      message
    end

    def upload_file_params
      params = {}

      params.merge!(wallet: id) if id
      params.merge!(fileName: file_name) if file_name
      params.merge!(type: type) if type
      params.merge!(buffer: buffer) if buffer

      params
    end

    def upload_file_message
      message = upload_file_params.merge!(
                  version: '1.1'
                )

      message
    end
  end
end
