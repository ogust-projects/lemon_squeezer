module LemonSqueezer
  class Transfer
    attr_accessor :id, :sender, :receiver, :amount, :debit, :credit, :commission, :status, :error

    SEND_PAYMENT_PARAMS = %i(debitWallet creditWallet amount)

    def initialize(params = {})
      @sender         = params[:sender]
      @receiver       = params[:receiver]
      @amount         = params[:amount]
      @message        = params[:message]
      @scheduled_date = params[:scheduled_date]
      @private_data   = params[:private_data]
    end

    def send_payment
      if LemonSqueezer::Utils.mandatory_params_present?(SEND_PAYMENT_PARAMS, send_payment_params)
        result  = LemonSqueezer::Request.new(url: 'send_payment', message: send_payment_message).response

        if result.has_key?(:trans)
          transfer        = result[:trans][:hpay]
          self.id         = transfer[:id]
          self.debit      = transfer[:deb].to_f
          self.credit     = transfer[:cred].to_f
          self.commission = transfer[:com].to_f
          self.status     = transfer[:status].to_i
        end

        if result.has_key?(:e)
          error      = result[:e]
          self.error =  {
                          code: error[:code],
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

    def send_payment_params
      params = {}

      params.merge!(debitWallet: @sender) if @sender
      params.merge!(creditWallet: @receiver) if @receiver
      params.merge!(amount: @amount) if @amount

      params
    end

    def send_payment_message
      message = send_payment_params.merge!(
                  version: '1.0'
                )

      message.merge!(message: @message) if @message
      message.merge!(scheduledDate: @scheduled_date) if @scheduled_date
      message.merge!(privateData: @private_data) if @private_data

      message
    end
  end
end
