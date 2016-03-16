require "spec_helper"

describe LemonSqueezer do
  context "test environment" do
    describe "#configure" do
      before :each do
        LemonSqueezer.configure do |config|
          config.production = false
        end
      end

      it "returns WSDL for test" do
        directkit_wsdl = LemonSqueezer.configuration.directkit_wsdl

        expect(directkit_wsdl).to be_a(String)
        expect(directkit_wsdl).to eq ENV["LEMONWAY_DIRECTKIT_WSDL"]
      end

      after :each do
        LemonSqueezer.reset
      end
    end
  end

  context "production environment" do
    describe "#configure" do
      before :each do
        LemonSqueezer.configure do |config|
          config.production     = true
          config.directkit_wsdl = "https://ws.lemonway.fr/mb/demo/dev/directkitjson/service.asmx?WSDL"
        end
      end

      it "returns WSDL for test" do
        directkit_wsdl = LemonSqueezer.configuration.directkit_wsdl

        expect(directkit_wsdl).to be_a(String)
        expect(directkit_wsdl).to eq "https://ws.lemonway.fr/mb/demo/dev/directkitjson/service.asmx?WSDL"
      end

      after :each do
        LemonSqueezer.reset
      end
    end
  end

  describe ".reset" do
    before :each do
      LemonSqueezer.configure do |config|
        config.production = true
      end
    end

    it "resets the configuration" do
      LemonSqueezer.reset

      config = LemonSqueezer.configuration

      expect(config.production).to eq(false)
    end
  end
end
