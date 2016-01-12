module LemonSqueezer
  class Card
    attr_accessor :id, :from_moneyin, :card_id, :sender, :sender_first_name, :sender_last_name, :receiver, :amount,
                  :card_type, :card_number, :card_crypto, :card_date, :message, :auto_commission, :register_card, :debit,
                  :credit, :commission, :status, :error

    TYPES = %i(cb visa mastercard)

    TYPES.each_with_index do |card_type, index|
      define_method("#{card_type}?") do
        @card_type == index
      end
    end

    FAST_PAY_PARAMS = %i(clientMail clientFirstName clientLastName cardType cardNumber cardCrypto cardDate creditWallet amount autoCommission registerCard)

    def initialize(params = {})
      @sender            = params[:sender]
      @sender_first_name = params[:sender_first_name]
      @sender_last_name  = params[:sender_last_name]
      @card_type         = params[:card_type]
      @card_number       = params[:card_number]
      @card_crypto       = params[:card_crypto]
      @card_date         = params[:card_date]
      @receiver          = params[:receiver]
      @amount            = params[:amount]
      @message           = params[:message]
      @auto_commission   = params[:auto_commission]
      @register_card     = params[:register_card]
    end

    def card_type
      TYPES[@card_type] if @card_type
    end

    def fast_pay
      if LemonSqueezer::Utils.mandatory_params_present?(FAST_PAY_PARAMS, fast_pay_params)
        result  = LemonSqueezer::Request.new(url: 'fast_pay', message: fast_pay_message).response

        if result.has_key?(:trans)
          transfer          = result[:trans][:hpay]
          self.id           = transfer[:id]
          self.from_moneyin = transfer[:from_moneyin]
          self.card_id      = transfer[:card_id]
          self.debit        = transfer[:deb].to_f
          self.credit       = transfer[:cred].to_f
          self.commission   = transfer[:com].to_f
          self.status       = transfer[:status].to_i
        end

        if result.has_key?(:e)
          error      = result[:e]
          self.error =  {
                          code: error[:code].to_i,
                          message: error[:msg]
                        }
        end
      else
        self.error =  {
                        code: -1,
                        message: 'Missing parameters'
                      }
      end

      self
    end

    def fast_pay_params
      params = {}

      params.merge!(clientMail: @sender) if @sender
      params.merge!(clientFirstName: @sender_first_name) if @sender_first_name
      params.merge!(clientLastName: @sender_last_name) if @sender_last_name
      params.merge!(cardType: @card_type.to_s) if @card_type
      params.merge!(cardNumber: @card_number) if @card_number
      params.merge!(cardCrypto: @card_crypto) if @card_crypto
      params.merge!(cardDate: @card_date) if @card_date
      params.merge!(creditWallet: @receiver) if @receiver
      params.merge!(amount: @amount) if @amount
      params.merge!(autoCommission: @auto_commission) if @auto_commission
      params.merge!(registerCard: @register_card) if @register_card

      params
    end

    def fast_pay_message
      message = fast_pay_params.merge!(
                  version: '1.2'
                )

      message.merge!(message: @message) if @message

      message
    end
  end
end
