require "spec_helper"

module LemonSqueezer
  describe Transfer do
    let(:transfer) {
      LemonSqueezer::Transfer.new(
        {
          sender: 'sc',
          receiver: 'rspecwallet',
          amount: 42.42
        }
      )
    }
    let(:invalid_transfer) {
      LemonSqueezer::Transfer.new(
        {
          sender: 'sc',
          receiver: 'sc',
          amount: 42.42
        }
      )
    }
    let(:no_transfer) { LemonSqueezer::Transfer.new }
    let(:shortcut_send_payment) { LemonSqueezer.transfer_send_payment }

    describe "#send_payment" do
      it "returns a LemonSqueezer::Transfer object" do
        expect(transfer).to be_a(LemonSqueezer::Transfer)
      end

      it "shortcut return a LemonSqueezer::Transfer object" do
        expect(shortcut_send_payment).to be_a(LemonSqueezer::Transfer)
      end

      it "send payment between main wallet and a supplier wallet" do
        transfer.send_payment
        expect(transfer.id).to be_a(String)
        expect(transfer.debit).to be_a(Float)
        expect(transfer.credit).to be_a(Float)
        expect(transfer.commission).to be_a(Float)
        expect(transfer.status).to be_a(Fixnum)
      end

      it "return an error" do
        invalid_transfer.send_payment
        expect(invalid_transfer.error).to be_a(Hash)
        expect(invalid_transfer.error[:code]).not_to eq -1
      end

      it "return error 250" do
        no_transfer.send_payment
        expect(no_transfer.error).to be_a(Hash)
        expect(no_transfer.error[:code]).to eq -1
      end
    end
  end
end
