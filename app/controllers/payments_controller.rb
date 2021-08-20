class PaymentsController < ApplicationController

  # GET /payments or /payments.json
  def index
    @notice=params[:notice]
    @payments = list_payment
  end

  # GET /payments/1 or /payments/1.json
  def show
    @payment = params[:payment].nil? ? get_payment(params[:id]).body.payment : params[:payment]
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
  def list_payment
    client=self.get_square_client
    payments=client.payments.list_payments(
      sort_order: "DESC",
      location_id: ENV['LOCATION_ID']
    )
    payments= payments.body.try(:payments).nil? ? [] :payments.body.payments
    return payments #upto 100 paymetns will return
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
  def get_payment(id)
    client=self.get_square_client
    result = client.payments.get_payment(
      payment_id: id
    )
  end
end
