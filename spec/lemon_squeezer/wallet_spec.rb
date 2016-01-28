require "spec_helper"

module LemonSqueezer
  describe Wallet do
    let(:main_wallet) { LemonSqueezer::Wallet.new({id: 'sc', email: LemonSqueezer.configuration.login}) }
    let(:invalid_wallet) { LemonSqueezer::Wallet.new({id: 'erratum', email: 'erratum@erratum.com'}) }
    let(:no_wallet) { LemonSqueezer::Wallet.new }
    let(:shortcut_wallet_get_details) {
      LemonSqueezer.wallet_get_details(
                                        {
                                          id: 'sc',
                                          email: LemonSqueezer.configuration.login
                                        }
                                      )
    }
    let(:register_wallet) {
      LemonSqueezer::Wallet.new(
                                  {
                                    id: random_string,
                                    email: random_email,
                                    first_name: random_string,
                                    last_name: random_string
                                  }
                                )
    }
    let(:register_existing_wallet) {
      LemonSqueezer::Wallet.new(
                                  {
                                    id: 'sc',
                                    email: LemonSqueezer.configuration.login,
                                    first_name: random_string,
                                    last_name: random_string
                                  }
                                )
    }
    let(:shortcut_wallet_register) {
      LemonSqueezer.wallet_register(
                                      {
                                        id: random_string,
                                        email: random_email,
                                        first_name: random_string,
                                        last_name: random_string
                                      }
                                    )
    }

    describe "#get_details" do
      it "returns a LemonSqueezer::Wallet object" do
        expect(main_wallet.get_details).to be_a(LemonSqueezer::Wallet)
      end

      it "shortcut return a LemonSqueezer::Wallet object" do
        expect(shortcut_wallet_get_details).to be_a(LemonSqueezer::Wallet)
      end

      it "get details of main wallet" do
        main_wallet.get_details
        expect(main_wallet.id).to be_a(String)
        expect(main_wallet.balance).to be_a(Float)
        expect(main_wallet.name).to be_a(String)
        expect(main_wallet.email).to be_a(String)
        expect(main_wallet.iban).to be_a(Array)
        expect(main_wallet.status).to be_a(Fixnum)
        expect([true, false]).to include(main_wallet.blocked)
      end

      it "return an error" do
        invalid_wallet.get_details
        expect(invalid_wallet.error).to be_a(Hash)
        expect(invalid_wallet.error[:code]).not_to eq -1
      end

      it "return an error 250" do
        no_wallet.get_details
        expect(no_wallet.error).to be_a(Hash)
        expect(no_wallet.error[:code]).to eq -1
      end
    end

    describe "#register" do
      it "returns a LemonSqueezer::Wallet object" do
        expect(register_wallet.register).to be_a(LemonSqueezer::Wallet)
      end

      it "shortcut return a LemonSqueezer::Wallet object" do
        expect(shortcut_wallet_register).to be_a(LemonSqueezer::Wallet)
      end

      it "get details of main wallet" do
        register_wallet.register
        expect(register_wallet.id).to be_a(String)
        expect(register_wallet.lwid).to be_a(String)
      end

      it "return an error" do
        register_existing_wallet.register
        expect(register_existing_wallet.error).to be_a(Hash)
        expect(register_existing_wallet.error[:code]).not_to eq -1
      end

      it "return an error 250" do
        no_wallet.register
        expect(no_wallet.error).to be_a(Hash)
        expect(no_wallet.error[:code]).to eq -1
      end
    end
  end
end
