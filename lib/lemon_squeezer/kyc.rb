module LemonSqueezer
  class Kyc
    attr_accessor :id, :lwid, :balance, :name, :first_name, :last_name, :birthdate, :nationality, :email, :ibans, :documents, :status, :blocked, :error, :payer_or_beneficiary,
                  :is_company, :company_name, :company_website, :company_description, :new_status, :start_date, :end_date, :hpay, :technical, :file_name, :type, :buffer, :country, :document_id, :config_name, :public_ip

    GET_DETAILS_PARAMS = %i(wallet email updateDate)

    FILE_TYPES = {'id_card': 0, 'proof_address': 1, 'bank_information': 2, 'passport_europe': 3, 'passport_not_europe': 4, 'residence permit': 5, 'company_registration': 7, 'other_11': 11, 'other_12': 12, 'other_13': 13, 'other_14': 14, 'other_15': 15, 'other_16': 16, 'other_17': 17, 'other_18': 18, 'other_19': 19, 'other_20': 20}

    def initialize(params = {})
      @id = params[:id]
      @lwid = params[:lwid]
      @email = params[:email]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @birthdate = params[:birthdate]
      @nationality = params[:nationality]
      @payer_or_beneficiary = params[:payer_or_beneficiary]
      @country = params[:country]
      @is_company = params[:is_company]
      @company_name = params[:company_name]
      @new_status = params[:new_status]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @technical = params[:technical]
      @file_name = params[:file_name]
      @type = (FILE_TYPES[params[:type].to_sym].to_s rescue '')
      @buffer = params[:buffer]
      @config_name = params[:config_name] || :DEFAULT
      @public_ip = params[:public_ip]
      @company_website = params[:company_website]
      @company_description = params[:company_description]
      @update_date = params[:update_date]
    end

    def details
      request = Request.new(GET_DETAILS_PARAMS, get_details_params, get_details_message, self.config_name, self.public_ip, :get_kyc_status, :wallet)

      Response.new(request).submit do |result, error|
        binding.pry
        if result
          self.id = result[:id]
          self.balance = result[:bal].to_f
          self.name = result[:name]
          self.email = result[:email]
          self.ibans = result[:ibans]
          self.documents = result[:docs]
          self.status = result[:status].to_i
          self.blocked = result[:blocked] == '1'
          self.first_name = result[:first_name]
          self.last_name = result[:last_name]
          self.birthdate = result[:birthdate]
          self.nationality = result[:nationality]
          self.payer_or_beneficiary = result[:payer_or_beneficiary].to_i
          self.country = result[:country]
          self.is_company = result[:is_company]
          self.company_name = result[:company_name]
          self.company_website = result[:company_website]
          self.company_description = result[:company_description]
        end

        self.error = error
      end

      self
    end

    private

    def get_details_params
      params = {}

      params.merge!(wallet: id) if id
      params.merge!(email: email) if email
      params.merge!(updateDate: @update_date) if @update_date

      params
    end

    def get_details_message
      message = get_details_params.merge!(
        version: '2.1'
      )

      message
    end
  end
end
