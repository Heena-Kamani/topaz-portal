class LineItem < ApplicationRecord
  belongs_to :quote

  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :quote_still_editable

  before_destroy :prevent_changes_to_accepted_quote

  def total_cents
    (quantity * unit_price_cents).round
  end

  # Forms work in dollars; the database works in cents.
  def unit_price
    unit_price_cents.to_i / 100.0
  end

  def unit_price=(dollars)
    self.unit_price_cents = (BigDecimal(dollars.to_s.delete(",$ ").presence || "0") * 100).round
  rescue ArgumentError
    self.unit_price_cents = nil
  end

  private

  def quote_still_editable
    errors.add(:base, "This quote was accepted and can't be changed") if quote&.accepted?
  end

  def prevent_changes_to_accepted_quote
    return unless quote&.accepted?
    errors.add(:base, "This quote was accepted and can't be changed")
    throw :abort
  end
end
