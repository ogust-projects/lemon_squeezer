module LemonSqueezer
  class Configuration
    attr_accessor :login, :password, :language, :production, :log

    def initialize
      @production = false
      @log        = true
    end

    def client
      @client ||= Savon.client(
                    log: @log,
                    env_namespace: :soapenv,
                    headers: {},
                    wsdl: directkit_wsdl
                  )
    end

    def directkit_wsdl
      if @production
        ""
      else
        "https://ws.lemonway.fr/mb/demo/dev/directkitjson/service.asmx?WSDL"
      end
    end

    def auth
      {
        wlLogin: @login,
        wlPass: @password,
        language: @language,
        walletIp: public_ip,
        walletUa: 'powered by LemonSqueezer'
      }
    end

    def public_ip
      @public_ip ||= ::Net::HTTP.get URI "https://api.ipify.org"
    end
  end
end
