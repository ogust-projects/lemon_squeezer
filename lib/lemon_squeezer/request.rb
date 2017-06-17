module LemonSqueezer
  class Request
    attr_accessor :mandatory_params, :params, :message, :config_name, :url, :root, :result

    def initialize(mandatory_params, params, message, config_name, public_ip, url, root, result = nil)
      
      @mandatory_params = mandatory_params
      @params           = params
      @config_name      = config_name
      @message          = message.merge(LemonSqueezer.configuration.auth(config_name, public_ip))
      @url              = url.to_sym
      @root             = root
      @result           = if result
                            result.to_sym
                          else
                            url.to_sym
                          end
    end

    def response
      response =  LemonSqueezer.configuration.client(self.config_name).call(
                    self.url,
                    message: {'p' => self.message}
                  )

      response.body["#{self.url}_response".to_sym]["#{self.result}_result".to_sym]
    end

  end
end
