require 'spec_helper'

module LemonSqueezer
  describe Configuration do
    describe '#production' do
      it 'default value is false' do
        config = Configuration.new

        expect(config.production).to eq(false)
      end
    end

    describe '#production=' do
      it 'can set value' do
        config            = Configuration.new
        config.production = true

        expect(config.production).to eq(true)
      end
    end

    describe '#configs=' do
      it 'can set value' do
        config       = Configuration.new
        config.configs = {:EUR => {:login => 'login@lemonway.fr'}}

        expect(config.configs[:EUR][:login]).to eq('login@lemonway.fr')
      end
    end
  end
end
