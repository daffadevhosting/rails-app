# app/controllers/generator_controller.rb
class GeneratorController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:pay] # jika pakai fetch API tanpa CSRF token

  def index
  end

  def pay
    prompt = params[:prompt] || JSON.parse(request.body.read)["prompt"]
    order_id = SecureRandom.uuid
    email = "test@example.com"
    amount = 2000

    midtrans = MidtransClient.new

    snap_token = midtrans.create_snap_token(
      order_id: order_id,
      amount: amount,
      email: email,
      prompt: prompt
    )

    render json: {
      snap_token: snap_token,
      order_id: order_id,
      prompt: prompt
    }
  rescue => e
    logger.error "Midtrans error: #{e.message}"
    render json: { error: "Gagal membuat transaksi Midtrans" }, status: 500
  end
end
