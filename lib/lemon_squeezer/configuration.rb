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
                                log: (self.configs[config_name][:log] if config_name),
                                env_namespace: :soapenv,
                                headers: {},
                                basic_auth: (config_name ? [self.configs[config_name][:login], self.configs[config_name][:password]] : [nil, nil]),
                                wsdl: (self.configs[config_name][:directkit_wsdl] if config_name)
                              )
    end

    def auth(config_name)
      {
        wlLogin: (self.configs[config_name][:login] if config_name),
        wlPass: (self.configs[config_name][:password] if config_name),
        language: (self.configs[config_name][:language] if config_name),
        walletIp: public_ip,
        walletUa: 'powered by LemonSqueezer'
      }
    end

    def public_ip
      '46.101.130.8' #@public_ip ||= ::Net::HTTP.get(URI("https://api.ipify.org"))
    end
  end
end
