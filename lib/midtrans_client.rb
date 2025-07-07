# lib/midtrans_client.rb
require "httparty"
require "base64"

class MidtransClient
  include HTTParty
  base_uri "https://api.sandbox.midtrans.com"

  def initialize(server_key = ENV["MIDTRANS_SERVER_KEY"])
    @auth = {
      "Authorization" => "Basic #{Base64.strict_encode64("#{server_key}:")}",
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  def create_snap_token(order_id:, amount:, email:, prompt:)
    body = {
      transaction_details: {
        order_id: order_id,
        gross_amount: amount
      },
      customer_details: {
        email: email
      },
      item_details: [
        {
          id: "ai-gen",
          price: amount,
          quantity: 1,
          name: "AI Image: #{prompt[0..20]}"
        }
      ]
    }

    res = self.class.post("/snap/v1/transactions", body: body.to_json, headers: @auth)

    raise "Midtrans error: #{res.body}" unless res.code == 201

    res.parsed_response["token"]
  end

  def check_status(order_id)
    res = self.class.get("/v2/#{order_id}/status", headers: @auth)

    raise "Status check error: #{res.body}" unless res.success?

    res.parsed_response
  end
end
