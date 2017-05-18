module LemonSqueezer
  class Iban
    attr_accessor :id, :status, :wallet, :holder, :bic, :iban, :agency, :address, :country, :comment, :error, :config_name

    REGISTER_PARAMS_FR = %i(wallet holder iban)
    REGISTER_PARAMS_NOT_FR = %i(wallet holder iban bic dom1 dom2)

    def initialize(params = {})
      iban_test = Ibanizator.iban_from_string(params[:iban])
      @config_name       = params[:config_name] || :DEFAULT
      if iban_test.valid?
        @wallet            = params[:wallet]
        @holder            = params[:holder]
        @bic               = params[:bic]
        @iban              = iban_test.to_s
        @agency            = params[:agency]
        @address           = params[:address]
        @country           = iban_test.country_code
        @comment           = params[:comment]
    end

    def register
      request_params =  if [:FR, :MC].include?(self.country)
                          REGISTER_PARAMS_FR
                        else
                          REGISTER_PARAMS_NOT_FR
                        end

      request = Request.new(request_params, register_params, register_message, self.config_name, :register_iban, :iban)

      Response.new(request).submit do |result, error|
        if result
          self.id     = result[:id].to_i
          self.status = result[:s].to_i
        end

        self.error = error
      end

      self
    end

    private

    def register_params
      params = {}

      params.merge!(wallet: self.wallet) if self.wallet
      params.merge!(holder: self.holder) if self.holder
      params.merge!(bic: self.bic) if self.bic
      params.merge!(iban: self.iban) if self.iban
      params.merge!(dom1: self.agency) if self.agency
      params.merge!(dom2: self.address) if self.address

      params
    end

    def register_message
      message = register_params.merge!(
                  version: '1.1'
                )

      message.merge!(comment: self.comment) if self.comment

      message
    end
  end
end
