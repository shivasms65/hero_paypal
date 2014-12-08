require "paypal/recurring"

p paypal_info = YAML.load_file("config/paypal.yml")[Rails.env]

PayPal::Recurring.configure do |config|
  config.sandbox = true
  config.username = paypal_info["username"]
  config.password = paypal_info["password"]
  config.signature = paypal_info["signature"]
end