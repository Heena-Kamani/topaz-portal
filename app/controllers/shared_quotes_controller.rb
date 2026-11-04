# What a client sees when they open their quote link.
# There's no login on this side: the long random token in the link is the key.
class SharedQuotesController < ApplicationController
  layout "client"

  before_action :set_quote

  def show
  end

  def accept
    @quote.accept!(name: params[:name])
    redirect_to shared_quote_path(@quote.share_token), notice: "Thank you! You've accepted this quote."
  rescue ArgumentError => e
    flash.now[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  private

  def set_quote
    @quote = Quote.where.not(status: "draft").find_by!(share_token: params[:token])
  end
end
