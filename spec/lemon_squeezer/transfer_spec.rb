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

    let(:iban_de) { Ibanizator.iban_from_string('DE68 2105 0170 0012 3456 78') }
    let(:bic) { iban_de.extended_data.bic }
    let(:bank) { Ibanizator.bank_db.bank_by_bic(bic) }
    let(:iban) {
      LemonSqueezer::Iban.new(
        {
          wallet: 'rspecwallet',
          holder: random_string,
          bic: bic,
          iban: iban_de,
          agency: bank.name,
          address: random_string
        }
      ).register
    }

    let(:transfer_ext) {
      LemonSqueezer::Transfer.new(
        {
          sender: 'rspecwallet',
          iban_id: iban.id,
          amount: 10.00,
          auto_comission: 0
        }
      )
    }
    let(:invalid_transfer_ext) {
      LemonSqueezer::Transfer.new(
        {
          sender: 'rspecwallet_error',
          iban_id: iban.id,
          amount: 10.00,
          auto_comission: 0
        }
      )
    }
    let(:no_transfer_ext) { LemonSqueezer::Transfer.new }
    let(:shortcut_money_out) { LemonSqueezer.transfer_money_out }

    describe "#send_payment" do
      it "returns a LemonSqueezer::Transfer object" do
        expect(transfer.send_payment).to be_a(LemonSqueezer::Transfer)
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
        expect(transfer.transfered_at).to be_a(DateTime)
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

    describe "#money_out" do
      it "returns a LemonSqueezer::Transfer object" do
        expect(transfer_ext.money_out).to be_a(LemonSqueezer::Transfer)
      end

      it "shortcut return a LemonSqueezer::Transfer object" do
        expect(shortcut_money_out).to be_a(LemonSqueezer::Transfer)
      end

      it "send payment between a supplier wallet to his IBAN" do
        transfer_ext.money_out
        expect(transfer_ext.id).to be_a(String)
        expect(transfer_ext.iban).to be_a(String)
        expect(transfer_ext.debit).to be_a(Float)
        expect(transfer_ext.credit).to be_a(Float)
        expect(transfer_ext.commission).to be_a(Float)
        expect(transfer_ext.status).to be_a(Fixnum)
        expect(transfer_ext.transfered_at).to be_a(DateTime)
      end

      it "return an error" do
        invalid_transfer_ext.money_out
        expect(invalid_transfer_ext.error).to be_a(Hash)
        expect(invalid_transfer_ext.error[:code]).not_to eq -1
      end

      it "return error 250" do
        no_transfer_ext.money_out
        expect(no_transfer_ext.error).to be_a(Hash)
        expect(no_transfer_ext.error[:code]).to eq -1
      end
    end
  end
end
