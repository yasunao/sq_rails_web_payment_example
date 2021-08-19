class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index
    client=get_square_client
    @payments = client.payments.list_payments.body.payments #upto 100 paymetns will return
    @payments = client.payments.list_payments(
      sort_order: "DESC",
      location_id: ENV['LOCATION_ID']
    )
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.fetch(:payment, {})
    end
    #
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
end
