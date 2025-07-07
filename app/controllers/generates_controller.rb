class GeneratesController < ApplicationController
  before_action :set_fingerprint

  def new
    @has_used_free = FreeGeneration.used_this_month?(@fingerprint)
  end

  def create
    prompt = params[:prompt]
    is_free = params[:free_trial] == "1"

    if is_free
      if FreeGeneration.used_this_month?(@fingerprint)
        render json: { error: "Kamu sudah menggunakan gratisan bulan ini." }, status: :forbidden
        return
      end

      FreeGeneration.create!(fingerprint: @fingerprint, used_at: Time.current)

      # Simulasi generate image (nanti diganti dengan backend AI-mu)
      image_url = "/placeholder.png"

      render json: { success: true, url: image_url }
    else
      snap_token = PaymentsHelper.generate_snap_token(prompt)
      render json: { snap_token: snap_token }
    end
  end

  private

  def set_fingerprint
    cookies.permanent[:fingerprint] ||= SecureRandom.hex(16)
    @fingerprint = cookies[:fingerprint]
  end
end
