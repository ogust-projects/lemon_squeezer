require "spec_helper"

module LemonSqueezer
  describe Card do
    let(:default_card) {
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
          register_card: 1,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
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
          register_card: 1,
          config_name: :EUR,
          public_ip: '46.101.130.8'
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
          register_card: 1,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:no_card) { LemonSqueezer::Card.new }
    let(:shortcut_fast_pay) { LemonSqueezer.card_fast_pay }

    describe ":DEFAULT" do
      it "returns a LemonSqueezer::Wallet object" do
        expect(default_card.fast_pay).to be_a(LemonSqueezer::Card)
      end
    end

    describe '#fast_pay' do
      it 'returns a LemonSqueezer::Card object' do
        expect(card.fast_pay).to be_a(LemonSqueezer::Card)
      end

      it 'shortcut return a LemonSqueezer::Card object' do
        expect(shortcut_fast_pay).to be_a(LemonSqueezer::Card)
      end

      it 'pay by fast pay to main wallet' do
        card.fast_pay
        expect(card.id).to be_a(String)
        expect(card.from_moneyin).to be_a(String)
        expect(card.card_id).to be_a(String)
        expect(card.debit).to be_a(BigDecimal)
        expect(card.credit).to be_a(BigDecimal)
        expect(card.commission).to be_a(BigDecimal)
        expect(card.status).to be_a(Integer)
        expect(card.error).to be_nil
      end

      it 'return an error' do
        invalid_card.fast_pay
        expect(invalid_card.error).to be_a(Hash)
        expect(invalid_card.error[:code]).not_to eq -1
      end

      it 'return error 250' do
        no_card.fast_pay
        expect(no_card.error).to be_a(Hash)
        expect(no_card.error[:code]).to eq -1
      end
    end

    let(:card_money_in) {
      LemonSqueezer::Card.new(
        {
          receiver: 'rspecwallet',
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now + 35).strftime("%m/%Y"),
          amount: 24.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:invalid_card_money_in) {
      LemonSqueezer::Card.new(
        {
          receiver: random_string,
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now + 35).strftime("%m/%Y"),
          amount: 24.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:no_card_money_in) { LemonSqueezer::Card.new }
    let(:shortcut_money_in) { LemonSqueezer.card_money_in }

    describe '#money_in' do
      it 'returns a LemonSqueezer::Card object' do
        expect(card_money_in.money_in).to be_a(LemonSqueezer::Card)
      end

      it 'shortcut return a LemonSqueezer::Card object' do
        expect(shortcut_money_in).to be_a(LemonSqueezer::Card)
      end

      it 'pay with a card to rspecwallet wallet' do
        card_money_in.money_in
        if card_money_in.error.blank?
          expect(card_money_in.id).to be_a(String)
          expect(card_money_in.credit).to be_a(BigDecimal)
          expect(card_money_in.commission).to be_a(BigDecimal)
          expect(card_money_in.status).to be_a(Integer)
        else
          expect(card_money_in.id).to be_nil
          expect(card_money_in.credit).to be_nil
          expect(card_money_in.commission).to be_nil
          expect(card_money_in.status).to be_nil
        end
        expect(card_money_in.card_number).to be_a(String)
        expect(card_money_in.receiver).to be_a(String)
      end

      it 'return an error' do
        invalid_card_money_in.money_in
        expect(invalid_card_money_in.error).to be_a(Hash)
        expect(invalid_card_money_in.error[:code]).not_to eq -1
      end

      it 'return error 250' do
        no_card_money_in.money_in
        expect(no_card_money_in.error).to be_a(Hash)
        expect(no_card_money_in.error[:code]).to eq -1
      end
    end

    let(:card_money_in_with_card_id) {
      LemonSqueezer::Card.new(
        {
          receiver: 'rspecwallet',
          card_id: card_registered.register.id,
          amount: 234.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:invalid_card_money_in_with_card_id) {
      LemonSqueezer::Card.new(
        {
          receiver: random_string,
          card_id: card_registered.register.id,
          amount: 234.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:no_card_money_in_with_card_id) { LemonSqueezer::Card.new }
    let(:shortcut_money_in_with_card_id) { LemonSqueezer.card_money_in_with_card_id }

    describe '#money_in_with_card_id' do
      it 'returns a LemonSqueezer::Card object' do
        expect(card_money_in_with_card_id.money_in_with_card_id).to be_a(LemonSqueezer::Card)
      end

      it 'shortcut return a LemonSqueezer::Card object' do
        expect(shortcut_money_in_with_card_id).to be_a(LemonSqueezer::Card)
      end

      it 'pay with a registred card to rspecwallet wallet' do
        card_money_in_with_card_id.money_in_with_card_id

        if card_money_in_with_card_id.error.blank?
          expect(card_money_in_with_card_id.id).to be_a(String)
          expect(card_money_in_with_card_id.credit).to be_a(BigDecimal)
          expect(card_money_in_with_card_id.commission).to be_a(BigDecimal)
          expect(card_money_in_with_card_id.status).to be_a(Integer)
          expect(card_money_in_with_card_id.card_number).to be_a(String)
          expect(card_money_in_with_card_id.from_moneyin).to be_a(String)
        else
          expect(card_money_in_with_card_id.id).to be_nil
          expect(card_money_in_with_card_id.credit).to be_nil
          expect(card_money_in_with_card_id.commission).to be_nil
          expect(card_money_in_with_card_id.status).to be_nil
          expect(card_money_in_with_card_id.card_number).to be_nil
          expect(card_money_in_with_card_id.from_moneyin).to be_nil
        end
        expect(card_money_in_with_card_id.receiver).to be_a(String)
      end

      it 'return an error' do
        invalid_card_money_in_with_card_id.money_in_with_card_id
        expect(invalid_card_money_in_with_card_id.error).to be_a(Hash)
        expect(invalid_card_money_in_with_card_id.error[:code]).not_to eq -1
      end

      it 'return error 250' do
        no_card_money_in_with_card_id.money_in_with_card_id
        expect(no_card_money_in_with_card_id.error).to be_a(Hash)
        expect(no_card_money_in_with_card_id.error[:code]).to eq -1
      end
    end

    let(:card_money_in_web_init) {
      LemonSqueezer::Card.new(
        {
          receiver: 'rspecwallet',
          amount: 234.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8',
          wk_token: '1245',
          return_url: 'https://localhost/return_url',
          error_url: 'https://localhost/error_url',
          cancel_url: 'https://localhost/cancel_url',
          register_card: 1,
          is_pre_auth: 1
        }
      )
    }
    let(:invalid_card_money_in_web_init) {
      LemonSqueezer::Card.new(
        {
          receiver: 'rspecwallet',
          amount: 234.56,
          auto_commission: 0,
          config_name: :EUR,
          public_ip: '46.101.130.8',
          wk_token: '1245',
          error_url: 'https://localhost/error_url',
          cancel_url: 'https://localhost/cancel_url',
          register_card: 1,
          is_pre_auth: 1
        }
      )
    }
    let(:no_card_money_in_web_init) { LemonSqueezer::Card.new }
    let(:shortcut_money_in_web_init) { LemonSqueezer.card_money_in_web_init }

    describe '#money_in_web_init' do
      it 'returns a LemonSqueezer::Card object' do
        expect(card_money_in_web_init.money_in_web_init).to be_a(LemonSqueezer::Card)
      end

      it 'shortcut return a LemonSqueezer::Card object' do
        expect(shortcut_money_in_web_init).to be_a(LemonSqueezer::Card)
      end

      it 'pay with a registred card to rspecwallet wallet' do
        card_money_in_web_init.money_in_web_init

        if card_money_in_web_init.error.blank?
          expect(card_money_in_web_init.id).to be_a(String)
          expect(card_money_in_web_init.card_id).to be_a(String)
          expect(card_money_in_web_init.token).to be_a(String)
        else
          expect(card_money_in_web_init.id).to be_nil
          expect(card_money_in_web_init.card_id).to be_nil
          expect(card_money_in_web_init.token).to be_nil
        end
        expect(card_money_in_web_init.receiver).to be_a(String)
      end

      it 'return an error' do
        invalid_card_money_in_web_init.money_in_web_init
        expect(invalid_card_money_in_web_init.error).to be_a(Hash)
        expect(invalid_card_money_in_web_init.error[:code]).to eq -1
      end

      it 'return error 250' do
        no_card_money_in_web_init.money_in_web_init
        expect(no_card_money_in_web_init.error).to be_a(Hash)
        expect(no_card_money_in_web_init.error[:code]).to eq -1
      end
    end

    let(:card_registered) {
      LemonSqueezer::Card.new(
        {
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now + 35).strftime("%m/%Y"),
          receiver: 'rspecwallet_tech',
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:invalid_card_registered) {
      LemonSqueezer::Card.new(
        {
          card_type: 1,
          card_number: '5017670000006700',
          card_crypto: '123',
          card_date: (DateTime.now + 35).strftime("%m/%Y"),
          receiver: random_string,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:no_card_registered) { LemonSqueezer::Card.new }
    let(:shortcut_card_registred) { LemonSqueezer.card_register }

    describe "#register" do
      it "returns a LemonSqueezer::Card object" do
        expect(card_registered.register).to be_a(LemonSqueezer::Card)
      end

      it "shortcut return a LemonSqueezer::Card object" do
        expect(shortcut_card_registred).to be_a(LemonSqueezer::Card)
      end

      it "pay by fast pay to main wallet" do
        card_registered.register
        expect(card_registered.id).to be_a(String)
        expect(card_registered.error).to be_nil
      end

      it "return an error" do
        invalid_card_registered.register
        expect(invalid_card_registered.error).to be_a(Hash)
        expect(invalid_card_registered.error[:code]).not_to eq -1
      end

      it "return error 250" do
        no_card_registered.register
        expect(no_card_registered.error).to be_a(Hash)
        expect(no_card_registered.error[:code]).to eq -1
      end
    end
  end
end
