module ApplicationHelper
  def money(cents)
    number_to_currency(cents.to_i / 100.0, unit: "$", precision: 2)
  end

  def tax_label(quote)
    percent = number_with_precision(quote.tax_rate_bps / 100.0, precision: 2, strip_insignificant_zeros: true)
    "GST (#{percent}%)"
  end

  def status_badge(quote)
    tag.span(quote.status.capitalize, class: "badge badge-#{quote.status}")
  end
end
