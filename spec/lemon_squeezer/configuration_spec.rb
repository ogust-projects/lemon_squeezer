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

    describe '#public_ip' do
      it 'can set value' do
        config       = Configuration.new
        config.configs = {:EUR => {:public_ip => '8.8.8.8'}}

        expect(config.public_ip(:EUR)).to eq('8.8.8.8')
      end
    end
  end
end
