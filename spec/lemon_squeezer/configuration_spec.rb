require "spec_helper"

module LemonSqueezer
  describe Configuration do
    describe "#production" do
      it "default value is false" do
        config = Configuration.new

        expect(config.production).to eq(false)
      end
    end

    describe "#production=" do
      it "can set value" do
        config            = Configuration.new
        config.production = true

        expect(config.production).to eq(true)
      end
    end

    describe "#login=" do
      it "can set value" do
        config       = Configuration.new
        config.login = 'login@lemonway.fr'

        expect(config.login).to eq('login@lemonway.fr')
      end
    end

    describe "#password=" do
      it "can set value" do
        config          = Configuration.new
        config.password = 'mysecurepassword'

        expect(config.password).to eq('mysecurepassword')
      end
    end

    describe "#language=" do
      it "can set value" do
        config          = Configuration.new
        config.language = 'fr'

        expect(config.language).to eq('fr')
      end
    end
  end
end
