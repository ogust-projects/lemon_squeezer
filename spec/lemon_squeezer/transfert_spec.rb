require "spec_helper"

module LemonSqueezer
  describe Transfert do
    let(:transfert) {
      LemonSqueezer::Transfert.new(
        {
          debit_wallet: 'sc',
          credit_wallet: 'rspecwallet',
          amount: 42.42
        }
      )
    }
    let(:invalid_transfert) {
      LemonSqueezer::Transfert.new(
        {
          debit_wallet: 'sc',
          credit_wallet: 'sc',
          amount: 42.42
        }
      )
    }
    let(:no_transfert) { LemonSqueezer::Transfert.new }
    let(:shorcut_send_payments) { LemonSqueezer.transfert_send_payment }

    describe "#send_payment" do
      it "returns a LemonSqueezer::Transfert object" do
        expect(transfert).to be_a(LemonSqueezer::Transfert)
      end

      it "shorcut return a LemonSqueezer::Wallet object" do
        expect(shorcut_send_payments).to be_a(LemonSqueezer::Transfert)
      end

      it "send payment between main wallet and a supplier wallet" do
        transfert.send_payment
        expect(transfert.id).to be_a(String)
        expect(transfert.debit).to be_a(Float)
        expect(transfert.credit).to be_a(Float)
        expect(transfert.commission).to be_a(Float)
        expect(transfert.status).to be_a(Fixnum)
      end

      it "return an error" do
        invalid_transfert.send_payment
        expect(invalid_transfert.error).to be_a(Hash)
        expect(invalid_transfert.error[:code]).not_to eq -1
      end

      it "return error 250" do
        no_transfert.send_payment
        expect(no_transfert.error).to be_a(Hash)
        expect(no_transfert.error[:code]).to eq -1
      end
    end
  end
end
