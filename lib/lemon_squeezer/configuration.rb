module LemonSqueezer
  class Configuration
    attr_accessor :configs, :production

    def initialize
      @production     = false
      @clients        = {}
      @configs        = {}
    end

    def client(config_name)
      unless @clients[config_name]
        prms = {
            log: self.configs[config_name][:log],
            env_namespace: :soapenv,
            headers: {},
            basic_auth: [self.configs[config_name][:login], self.configs[config_name][:password]],
            wsdl: self.configs[config_name][:directkit_wsdl]
        }
        prms[:proxy] = self.configs[config_name][:proxy] if self.configs[config_name][:proxy]
        @clients[config_name] = Savon.client(prms)
      end
      @clients[config_name]
    end

    def auth(config_name, public_ip)
      {
        wlLogin: self.configs[config_name][:login],
        wlPass: self.configs[config_name][:password],
        language: self.configs[config_name][:language],
        walletIp: public_ip,# || '46.101.130.8',
        walletUa: 'powered by LemonSqueezer'
      }
    end
  end
end
