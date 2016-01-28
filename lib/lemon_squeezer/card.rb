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

    def card_type_label
      TYPES[@card_type] if @card_type
    end

    def fast_pay
      request = Request.new(FAST_PAY_PARAMS, fast_pay_params, fast_pay_message, :fast_pay, :trans)

      Response.new(request).submit do |result, error|
        if result
          self.id           = result[:hpay][:id]
          self.from_moneyin = result[:hpay][:from_moneyin]
          self.card_id      = result[:hpay][:card_id]
          self.debit        = BigDecimal.new(result[:hpay][:deb])
          self.credit       = BigDecimal.new(result[:hpay][:cred])
          self.commission   = BigDecimal.new(result[:hpay][:com])
          self.status       = result[:hpay][:status].to_i
        end

        self.error = error
      end

      self
    end

    private

    def fast_pay_params
      params = {}

      params.merge!(clientMail: self.sender) if self.sender
      params.merge!(clientFirstName: self.sender_first_name) if self.sender_first_name
      params.merge!(clientLastName: self.sender_last_name) if self.sender_last_name
      params.merge!(cardType: self.card_type.to_s) if self.card_type
      params.merge!(cardNumber: self.card_number) if self.card_number
      params.merge!(cardCrypto: self.card_crypto) if self.card_crypto
      params.merge!(cardDate: self.card_date) if self.card_date
      params.merge!(creditWallet: self.receiver) if self.receiver
      params.merge!(amount: self.amount) if self.amount
      params.merge!(autoCommission: self.auto_commission) if self.auto_commission
      params.merge!(registerCard: self.register_card) if self.register_card

      params
    end

    def fast_pay_message
      message = fast_pay_params.merge!(
                  version: '1.2'
                )

      message.merge!(message: self.message) if self.message

      message
    end
  end
end
