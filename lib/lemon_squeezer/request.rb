module LemonSqueezer
  class Request
    attr_accessor :mandatory_params, :params, :message, :url, :root, :result

    def initialize(mandatory_params, params, message, url, root, result = nil)
      @mandatory_params = mandatory_params
      @params           = params
      @message          = message.merge(LemonSqueezer.configuration.auth)
      @url              = url.to_sym
      @root             = root
      @result           = if result
                            result.to_sym
                          else
                            url.to_sym
                          end
    end

    def response
      response =  LemonSqueezer.configuration.client.call(
                    self.url,
                    message: self.message
                  )

      response.body["#{self.url}_response".to_sym]["#{self.result}_result".to_sym]
    end

  end
end
