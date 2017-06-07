require 'spec_helper'

module LemonSqueezer
  describe Iban do
    let(:iban_de) { Ibanizator.iban_from_string('DE68 2105 0170 0012 3456 78') }
    let(:bic) { iban_de.extended_data.bic }
    let(:bank) { Ibanizator.bank_db.bank_by_bic(bic) }
    let(:default_iban) {
      LemonSqueezer::Iban.new(
        {
          wallet: 'rspecwallet',
          holder: random_string,
          bic: bic,
          iban: iban_de,
          agency: bank.name,
          address: random_string,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:iban) {
      LemonSqueezer::Iban.new(
        {
          wallet: 'rspecwallet',
          holder: random_string,
          bic: bic,
          iban: iban_de,
          agency: bank.name,
          address: random_string,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:invalid_iban) {
      LemonSqueezer::Iban.new(
        {
          wallet: 'rspecwallet',
          holder: random_string,
          bic: 'bic',
          iban: iban_de,
          agency: bank.name,
          address: random_string,
          config_name: :EUR,
          public_ip: '46.101.130.8'
        }
      )
    }
    let(:no_iban) { LemonSqueezer::Iban.new }
    let(:shortcut_iban_register) { LemonSqueezer.iban_register }

    describe ':DEFAULT' do
      it 'returns a LemonSqueezer::Wallet object' do
        expect(default_iban.register).to be_a(LemonSqueezer::Iban)
      end
    end

    describe '#register' do
      it 'returns a LemonSqueezer::Iban object' do
        expect(iban.register).to be_a(LemonSqueezer::Iban)
      end

      it 'shortcut return a LemonSqueezer::Iban object' do
        expect(shortcut_iban_register).to be_a(LemonSqueezer::Iban)
      end

      it 'register an IBAN to RSpec wallet' do
        iban.register
        expect(iban.id).to be_a(Fixnum)
        expect(iban.status).to be_a(Fixnum)
        expect(iban.error).to be_nil
      end

      it 'return an error' do
        invalid_iban.register
        expect(invalid_iban.error).to be_a(Hash)
        expect(invalid_iban.error[:code]).not_to eq -1
      end

      it 'return error 250' do
        no_iban.register
        expect(no_iban.error).to be_a(Hash)
        expect(no_iban.error[:code]).to eq -1
      end
    end
  end
end
