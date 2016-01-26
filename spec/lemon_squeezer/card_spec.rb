require "spec_helper"

module LemonSqueezer
  describe Card do
    let(:card) {
      LemonSqueezer::Card.new(
        {
          sender: random_email,
          sender_first_name: random_string,
          sender_last_name: random_string,
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now + 35).strftime("%m/%Y"),
          receiver: 'sc',
          amount: 234.56,
          auto_commission: 0,
          register_card: 1
        }
      )
    }
    let(:invalid_card) {
      LemonSqueezer::Card.new(
        {
          sender: random_email,
          sender_first_name: random_string,
          sender_last_name: random_string,
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now - 35).strftime("%m/%Y"),
          receiver: 'sc',
          amount: 234.56,
          auto_commission: 0,
          register_card: 1
        }
      )
    }
    let(:no_card) { LemonSqueezer::Card.new }
    let(:shortcut_fast_pay) { LemonSqueezer.card_fast_pay }

    describe "#fast_pay" do
      it "returns a LemonSqueezer::Card object" do
        expect(card.fast_pay).to be_a(LemonSqueezer::Card)
      end

      it "shortcut return a LemonSqueezer::Card object" do
        expect(shortcut_fast_pay).to be_a(LemonSqueezer::Card)
      end

      it "pay by fast pay to main wallet" do
        card.fast_pay
        expect(card.id).to be_a(String)
        expect(card.from_moneyin).to be_a(String)
        expect(card.card_id).to be_a(String)
        expect(card.debit).to be_a(BigDecimal)
        expect(card.credit).to be_a(BigDecimal)
        expect(card.commission).to be_a(BigDecimal)
        expect(card.status).to be_a(Fixnum)
      end

      it "return an error" do
        invalid_card.fast_pay
        expect(invalid_card.error).to be_a(Hash)
        expect(invalid_card.error[:code]).not_to eq -1
      end

      it "return error 250" do
        no_card.fast_pay
        expect(no_card.error).to be_a(Hash)
        expect(no_card.error[:code]).to eq -1
      end
    end
  end
end
