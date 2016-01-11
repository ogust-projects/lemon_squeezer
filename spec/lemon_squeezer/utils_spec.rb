require "spec_helper"

module LemonSqueezer
  describe Utils do
    let(:mandatory_params) { %i(params1 params2 params3) }
    let(:valid_params) { {params1: 'a', params2: 'a', params3: 'a', params4: 'a'} }
    let(:invalid_params) { {params1: 'a', params2: 'a'} }

    describe "#mandatory_params_present?" do
      it "return true" do
        expect(Utils.mandatory_params_present?(mandatory_params, valid_params)).to eq(true)
      end

      it "return false" do
        expect(Utils.mandatory_params_present?(mandatory_params, invalid_params)).to eq(false)
      end
    end
  end
end
