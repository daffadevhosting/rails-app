class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  def check_status
    order_id = params[:order_id]
    midtrans = MidtransClient.new
    status = midtrans.check_status(order_id)
    render json: status
  end
end
