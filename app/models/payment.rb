class Payment < ActiveRecord::Base

  def self.checkout_recurring_paypal(success_path, cancel_path, ipn_path)
    ppr = PayPal::Recurring.new({
                                    :return_url   => APP_URL + success_path,
                                    :cancel_url   => APP_URL + cancel_path,
                                    :ipn_url      => APP_URL + ipn_path,
                                    :description  => "Awesome - Monthly HeroTalkies Subscription",
                                    :amount       => "7.00",
                                    :currency     => "USD"
                                })

    response = ppr.checkout
  end

  def self.get_checkout_details(token)
    ppr = PayPal::Recurring.new(:token => token)
    response = ppr.checkout_details

    # Puts for details
    p response.email
    p response.first_name
    p response.last_name
    p response.status
    p response.trust # Gave All Details

    response
  end

  def self.request_payment(token, payer_id)
    ppr = PayPal::Recurring.new({
                                    :token       => token,
                                    :payer_id    => payer_id,
                                    :amount      => "7.00",
                                    :description => "Awesome - Monthly HeroTalkies Subscription"
                                })
    response = ppr.request_payment
  end

  def self.create_recurring_profile(token)
    ppr = PayPal::Recurring.new({
                                    :amount      => "7.00",
                                    :currency    => "USD",
                                    :description => "Awesome - Monthly HeroTalkies Subscription",
                                    :ipn_url     => "http://localhost:3000/payments/ipn",
                                    :frequency   => 1,
                                    :token       => token,
                                    :period      => :monthly,
                                    :reference   => "#{Time.now.to_i}",
                                    :payer_id    => "WTTS5KC2T46YU",
                                    :start_at    => Time.now,
                                    :failed      => 1,
                                    :outstanding => :next_billing
                                })

    response = ppr.create_recurring_profile
  end
end
