class PaymentsController < ApplicationController

  def index
    response = Payment.checkout_recurring_paypal(success_payments_path, canceled_payments_path, ipn_payments_path)

    if response.valid?
      puts response.checkout_url
      redirect_to response.checkout_url
    else
      flash[:errors] = response.errors[0][:messages]
      redirect_to failed_payments_path
    end
  end

  # User Authorize the payment Request
  def success
    token = params[:token]
    payer_id = params[:PayerID]

    # Get Checkout Details
    Payment.get_checkout_details(token)

    response = Payment.request_payment(token, payer_id)

    if response.approved? && response.completed?
      # Create Recurring Profile
      response = Payment.create_recurring_profile(token)
      puts response.profile_id

      Payment.create(:user_id => 1, :token => token, :profile_id => response.profile_id)

      return redirect_to completed_payments_path
    else
      messages = response.errors[0][:messages]
      flash[:errors] = messages
      return redirect_to failed_payments_path
    end
  end

  # User Reject the payment Request
  def canceled
    p params
    #TODO: we can update this detail while logged in user Canceled payment
    redirect_to root_path
  end

  def ipn
    p params
    #TODO: Have to check
    redirect_to root_path
  end

  # After successfully completed payment
  def completed

  end

  def failed
    p flash[:errors]
  end
end
