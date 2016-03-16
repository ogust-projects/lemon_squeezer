module LemonSqueezer
  class Configuration
    attr_accessor :login, :password, :language, :production, :log, :directkit_wsdl

    def initialize
      @production     = false
      @log            = true
      @directkit_wsdl = ""
    end

    def client
      @client ||= Savon.client(
                    log: self.log,
                    env_namespace: :soapenv,
                    headers: {},
                    basic_auth: [self.login, self.password],
                    wsdl: self.directkit_wsdl
                  )
    end

    def auth
      {
        wlLogin: self.login,
        wlPass: self.password,
        language: self.language,
        walletIp: public_ip,
        walletUa: 'powered by LemonSqueezer'
      }
    end

    def public_ip
      '46.101.130.8' #@public_ip ||= ::Net::HTTP.get(URI("https://api.ipify.org"))
    end
  end
end
