class FreeGeneration < ApplicationRecord
  validates :fingerprint, presence: true

  def self.used_this_month?(fingerprint)
    where(fingerprint:).where("used_at >= ?", Time.current.beginning_of_month).exists?
  end
end
