module LemonSqueezer
  class Card
    attr_accessor :id, :from_moneyin, :card_id, :sender, :sender_first_name, :sender_last_name, :receiver, :amount,
                  :card_type, :card_number, :card_crypto, :card_date, :message, :auto_commission, :register_card, :debit,
                  :credit, :commission, :status, :error, :config_name, :public_ip

    TYPES = %i(cb visa mastercard)

    TYPES.each_with_index do |card_type, index|
      define_method("#{card_type}?") do
        @card_type == index
      end
    end

    FAST_PAY_PARAMS              = %i(clientMail clientFirstName clientLastName cardType cardNumber cardCrypto cardDate creditWallet amount autoCommission registerCard)
    MONEY_IN_PARAMS              = %i(wallet cardType cardNumber cardCrypto cardDate amountTot)
    MONEY_IN_WITH_CARD_ID_PARAMS = %i(wallet cardId amountTot autoCommission)
    REGISTER_PARAMS              = %i(wallet cardType cardNumber cardCode cardDate)

    def initialize(params = {})
      @sender            = params[:sender]
      @sender_first_name = params[:sender_first_name]
      @sender_last_name  = params[:sender_last_name]
      @card_id           = params[:card_id]
      @card_type         = params[:card_type]
      @card_number       = params[:card_number]
      @card_crypto       = params[:card_crypto]
      @card_date         = params[:card_date]
      @receiver          = params[:receiver]
      @amount            = params[:amount]
      @message           = params[:message]
      @auto_commission   = params[:auto_commission]
      @register_card     = params[:register_card]
      @config_name       = params[:config_name] || :DEFAULT
      @public_ip         = params[:public_ip]
    end

    def card_type_label
      TYPES[@card_type] if @card_type
    end

    def fast_pay
      request = Request.new(FAST_PAY_PARAMS, fast_pay_params, fast_pay_message, self.config_name, self.public_ip, :fast_pay, :trans)

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

    def money_in
      request = Request.new(MONEY_IN_PARAMS, money_in_params, money_in_message, self.config_name, self.public_ip, :money_in, :trans)

      Response.new(request).submit do |result, error|

        if result
          self.id          = result[:hpay][:id]
          self.card_number = result[:hpay][:mlabel]
          self.credit      = BigDecimal.new(result[:hpay][:cred])
          self.commission  = BigDecimal.new(result[:hpay][:com])
          self.status      = result[:hpay][:status].to_i
        end

        self.error = error
      end

      self
    end

    def money_in_with_card_id
      request = Request.new(MONEY_IN_WITH_CARD_ID_PARAMS, money_in_with_card_id_params, money_in_with_card_id_message, self.config_name, self.public_ip, :money_in_with_card_id, :trans, :money_in)

      Response.new(request).submit do |result, error|
        if result
          self.id          = result[:hpay][:id]
          self.card_number = result[:hpay][:mlabel]
          self.credit      = BigDecimal.new(result[:hpay][:cred])
          self.commission  = BigDecimal.new(result[:hpay][:com])
          self.status      = result[:hpay][:status].to_i
        end

        self.error = error
      end

      self
    end

    def register
      request = Request.new(REGISTER_PARAMS, register_params, register_message, self.config_name, self.public_ip, :register_card, :card)

      Response.new(request).submit do |result, error|
        if result
          self.id = result[:id]
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

    def money_in_params
      params = {}

      params.merge!(wallet: self.receiver) if self.receiver
      params.merge!(cardType: self.card_type) if self.card_type
      params.merge!(cardNumber: self.card_number) if self.card_number
      params.merge!(cardCrypto: self.card_crypto) if self.card_crypto
      params.merge!(cardDate: self.card_date) if self.card_date
      params.merge!(amountTot: self.amount) if self.amount

      params
    end

    def money_in_message
      message = money_in_params.merge!(
                  version: '1.1'
                )

      message.merge!(amountCom: self.commission) if self.commission
      message.merge!(comment: self.message) if self.message

      message
    end

    def money_in_with_card_id_params
      params = {}

      params.merge!(wallet: self.receiver) if self.receiver
      params.merge!(cardId: self.card_id) if self.card_id
      params.merge!(amountTot: self.amount) if self.amount
      params.merge!(autoCommission: self.auto_commission) if self.auto_commission

      params
    end

    def money_in_with_card_id_message
      message = money_in_with_card_id_params.merge!(
                  version: '1.1'
                )

      message.merge!(amountCom: self.commission) if self.commission
      message.merge!(message: self.message) if self.message

      message
    end

    def register_params
      params = {}

      params.merge!(wallet: self.receiver) if self.receiver
      params.merge!(cardType: self.card_type) if self.card_type
      params.merge!(cardNumber: self.card_number) if self.card_number
      params.merge!(cardCode: self.card_crypto) if self.card_crypto
      params.merge!(cardDate: self.card_date) if self.card_date

      params
    end

    def register_message
      message = register_params.merge!(
                  version: '1.2'
                )

      message
    end
  end
end
