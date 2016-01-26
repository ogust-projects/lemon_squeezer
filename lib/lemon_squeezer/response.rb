module LemonSqueezer
  class Response
    attr_accessor :request

    def initialize(request)
      @request = request
    end

    def submit
      result, error = if mandatory_params_present?(self.request.mandatory_params, self.request.params)
        response  = @request.response

        result = if response.has_key?(@request.root)
          response[@request.root]
        end

        error = if response.has_key?(:e)
          { code: response[:e][:code].to_i, message: response[:e][:msg] }
        end

        [result, error]
      else
        [nil, { code: -1, message: 'Missing parameters' }]
      end

      yield result, error
    end

    private
    def mandatory_params_present?(mandatory_params, params)
      mandatory_params.map {|p| params.has_key?(p)}.all?
    end
  end
end
