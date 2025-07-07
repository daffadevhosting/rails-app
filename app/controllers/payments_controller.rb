class PaymentsController < ApplicationController
  def midtrans_checkout
    prompt = params[:prompt]
    snap_token = PaymentsHelper.generate_snap_token(prompt)

    render json: { snap_token: snap_token }
  end
end
