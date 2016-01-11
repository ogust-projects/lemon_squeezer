module LemonSqueezer
  class Request
    attr_accessor :url, :message

    def initialize(params)
      @url     = params[:url]
      @message = params[:message]
    end

    def response
      response = LemonSqueezer.configuration.client.call(@url.to_sym, message: @message.merge(LemonSqueezer.configuration.auth))

      response.body["#{@url}_response".to_sym]["#{@url}_result".to_sym]
    end

  end
end
