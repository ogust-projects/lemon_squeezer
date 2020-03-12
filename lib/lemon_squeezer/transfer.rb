module LemonSqueezer
  class Transfer
    attr_accessor :id, :sender, :receiver, :iban, :iban_id, :amount, :debit, :credit, :commission, :status, :error, :message, :scheduled_date, :private_data, :auto_comission, :transfered_at, :config_name, :public_ip

    SEND_PAYMENT_PARAMS = %i(debitWallet creditWallet amount)
    MONEY_OUT_PARAMS = %i(wallet amountTot autoCommission)

    def initialize(params = {})
      @sender         = params[:sender]
      @receiver       = params[:receiver]
      @iban_id        = params[:iban_id]
      @amount         = params[:amount]
      @message        = params[:message]
      @scheduled_date = params[:scheduled_date]
      @private_data   = params[:private_data]
      @auto_comission = params[:auto_comission]
      @config_name    = params[:config_name] || :DEFAULT
      @public_ip      = params[:public_ip]
    end

    def send_payment
      request = Request.new(SEND_PAYMENT_PARAMS, send_payment_params, send_payment_message, self.config_name, self.public_ip, :send_payment, :trans)

      Response.new(request).submit do |result, error|
        if result
          self.id            = result[:hpay][:id]
          self.debit         = result[:hpay][:deb].to_f
          self.credit        = result[:hpay][:cred].to_f
          self.commission    = result[:hpay][:com].to_f
          self.status        = result[:hpay][:status].to_i
          self.transfered_at = DateTime.parse(result[:hpay][:date])
        end

        self.error = error
      end

      self
    end

    def money_out
      request = Request.new(MONEY_OUT_PARAMS, money_out_params, money_out_message, self.config_name, self.public_ip, :money_out, :trans)

      Response.new(request).submit do |result, error|
        if result
          self.id            = result[:hpay][:id]
          self.iban          = result[:hpay][:mlabel]
          self.debit         = result[:hpay][:deb].to_f
          self.credit        = result[:hpay][:cred].to_f
          self.commission    = result[:hpay][:com].to_f
          self.status        = result[:hpay][:status].to_i
          self.transfered_at = DateTime.parse(result[:hpay][:date])
        end

        self.error = error
      end

      self
    end

    private

    def send_payment_params
      params = {}

      params.merge!(debitWallet: self.sender) if self.sender
      params.merge!(creditWallet: self.receiver) if self.receiver
      params.merge!(amount: format_amount(self.amount)) if self.amount

      params
    end

    def send_payment_message
      message = send_payment_params.merge!(
                  version: '2.5'
                )

      message.merge!(message: self.message) if self.message
      message.merge!(scheduledDate: self.scheduled_date) if self.scheduled_date
      message.merge!(privateData: self.private_data) if self.private_data

      message
    end

    def money_out_params
      params = {}

      params.merge!(wallet: self.sender) if self.sender
      params.merge!(amountTot: format_amount(self.amount)) if self.amount
      params.merge!(autoCommission: self.auto_comission) if self.auto_comission

      params
    end

    def money_out_message
      message = money_out_params.merge!(
                  version: '2.5'
                )

      message.merge!(amountCom: self.commission) if self.commission
      message.merge!(message: self.message) if self.message
      message.merge!(ibanId: self.iban_id) if self.iban_id

      message
    end

    def format_amount(amount)
      "%.2f" %amount
    end
  end
end
