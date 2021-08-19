class PaymentsController < ApplicationController

  # GET /payments or /payments.json
  def index
    @notice=params[:notice]
    client=get_square_client
    @payments = client.payments.list_payments(
      sort_order: "DESC",
      location_id: ENV['LOCATION_ID']
    ).body.payments #upto 100 paymetns will return
  end

  # GET /payments/1 or /payments/1.json
  def show
    @payment = params[:payment].nil? ? "Payment.find(params[:id])" : params[:payment]
    @notice=params[:notice]
  end

  # GET /payments/new
  def new
    @notice=params[:notice]
    @price=params[:price]
    gon.application_id=ENV['APPLICATION_ID']
    gon.location_id=ENV['LOCATION_ID']
  end

  # POST /payments or /payments.json
  def create
    @payment=create_payment(params[:nonce],params[:price].to_i)
    respond_to do |format|
      if @payment.success?
        format.html { redirect_to payment_path(@payment.body.payment[:id], payment: @payment.body.payment, notice: "Payment was successfully created." )}
        #format.json { render :show, status: :created, location: @payment }
      else
        format.html { redirect_to action: :new, 'data-turbolinks': false,price: params[:price],notice: "Payment was unprocessable" }
        #format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def get_square_client
      access_token=ENV['SQUARE_ACCESS_TOKEN']
      location_id=ENV['LOCATION_ID']
      case Rails.env
      when"production"
        environment="production"
      else
        environment='sandbox'
      end
      client = Square::Client.new(
        access_token: access_token,
        environment: environment
      )
      return client
    end
    def create_payment(nonce, price)
      client=self.get_square_client
      location_id=ENV['LOCATION_ID']
      result = client.payments.create_payment(
        body: {
          source_id: nonce,
          idempotency_key: SecureRandom.uuid(),
          amount_money: {
            amount: price,
            currency: "JPY"
          },
          location_id: location_id
        }
      )
      return result
    end
end
