module LemonSqueezer
  class Configuration
    attr_accessor :configs, :production

    def initialize
      @production     = false
      @clients        = {}
      @configs        = {}
    end

    def client(config_name)
      @clients[config_name] ||= Savon.client(
                                log: self.configs[config_name][:log],
                                env_namespace: :soapenv,
                                headers: {},
                                basic_auth: [self.configs[config_name][:login], self.configs[config_name][:password]],
                                wsdl: self.configs[config_name][:directkit_wsdl]
                              )
    end

    def auth(config_name)
      {
        wlLogin: self.configs[config_name][:login],
        wlPass: self.configs[config_name][:password],
        language: self.configs[config_name][:language],
        walletIp: public_ip(config_name),
        walletUa: 'powered by LemonSqueezer'
      }
    end

    def public_ip(config_name)
      self.configs[config_name][:public_ip] || '46.101.130.8' #@public_ip ||= ::Net::HTTP.get(URI("https://api.ipify.org"))
    end
  end
end
