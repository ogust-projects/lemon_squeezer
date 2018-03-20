require 'spec_helper'

module LemonSqueezer
  describe Kyc do
    let(:register_wallet) do
      LemonSqueezer::Wallet.new(
        id: 'sc',
        email: 'society@lemonway.fr',
        first_name: random_string,
        last_name: random_string,
        birthdate: random_date,
        nationality: 'FRA',
        country: 'FRA',
        is_company: 0,
        payer_or_beneficiary: 1,
        technical: 1,
        config_name: :EUR,
        public_ip: '46.101.130.8'
      )
    end
    let(:file_to_upload) do
      Base64.encode64(
        File.open('./spec/fixtures/files/upload_test1.pdf', 'rb').read
      )
    end
    let(:upload_file_wallet) do
      LemonSqueezer::Wallet.new(
        id: register_wallet.register.id,
        file_name: 'upload_test.pdf',
        type: 'proof_address',
        buffer: file_to_upload,
        config_name: :EUR,
        public_ip: '46.101.130.8'
      )
    end
    let(:kyc) do
      LemonSqueezer::Kyc.new(id: register_wallet.id,
                             email: register_wallet.email,
                             config_name: :EUR, public_ip: '46.101.130.8',
                             update_date: (Date.today - 30).to_time.to_i)
    end

    describe ':DEFAULT' do
      it 'returns a LemonSqueezer::Kyc object' do
        upload_file_wallet.upload_file
        expect(kyc).to be_a(LemonSqueezer::Kyc)
        kyc.details
      end
    end
  end
end
