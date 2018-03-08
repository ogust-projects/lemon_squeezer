module LemonSqueezer
  class Kyc
    GET_DETAILS_PARAMS = %i[wallet email updateDate].freeze
    def initialize(params = {})
      @id                   = params[:id]
      @lwid                 = params[:lwid]
    end

    def get_details
      request = Request.new(GET_DETAILS_PARAMS,
                            get_details_params,
                            get_details_message,
                            self.config_name,
                            self.public_ip,
                            :get_wallet_details,
                            :wallet)

      Response.new(request).submit do |result, error|
        if result
          self.result = result
        end

        self.error = error
      end
    end
  end
end