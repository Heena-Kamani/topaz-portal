class Quote < ApplicationRecord
  STATUSES = %w[draft sent accepted].freeze

  belongs_to :client
  has_many :line_items, -> { order(:position, :id) }, dependent: :destroy, inverse_of: :quote

  # The private link the client opens. Long and random, so it can't be guessed.
  has_secure_token :share_token, length: 32

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :tax_rate_bps, numericality: { only_integer: true, in: 0..10_000 }
  validate :locked_once_accepted, on: :update

  before_destroy :prevent_destroying_accepted

  def accepted?
    status == "accepted"
  end

  def editable?
    !accepted?
  end

  # All money is kept in whole cents so nothing drifts from float rounding.
  def subtotal_cents
    line_items.sum(&:total_cents)
  end

  def tax_cents
    (subtotal_cents * tax_rate_bps / 10_000.0).round
  end

  def total_cents
    subtotal_cents + tax_cents
  end

  def send_to_client!
    raise ArgumentError, "Accepted quotes can't be re-sent" if accepted?
    update!(status: "sent")
  end

  # The client types their name to accept. We store the total they saw,
  # so there's a record of exactly what was agreed to.
  def accept!(name:)
    raise ArgumentError, "Please type your name to accept" if name.to_s.strip.empty?
    raise ArgumentError, "This quote isn't ready to accept yet" unless status == "sent"

    with_lock do
      update!(
        status: "accepted",
        accepted_at: Time.current,
        accepted_by_name: name.strip,
        accepted_total_cents: total_cents
      )
    end
  end

  private

  def locked_once_accepted
    return unless status_was == "accepted"
    errors.add(:base, "This quote was accepted and can't be changed") if changed?
  end

  def prevent_destroying_accepted
    return unless accepted?
    errors.add(:base, "Accepted quotes are kept as a record")
    throw :abort
  end
end
