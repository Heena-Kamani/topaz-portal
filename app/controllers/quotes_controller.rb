class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy send_to_client]

  def index
    @quotes = Quote.includes(:client, :line_items).order(updated_at: :desc)
  end

  def show
    @line_item = LineItem.new
  end

  def new
    @quote = Quote.new(client_id: params[:client_id])
  end

  def create
    @quote = Quote.new(quote_params)
    if @quote.save
      redirect_to @quote, notice: "Quote started. Add the first line below."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quote.destroy
      redirect_to quotes_path, notice: "Quote deleted."
    else
      redirect_to @quote, alert: @quote.errors.full_messages.to_sentence
    end
  end

  def send_to_client
    @quote.send_to_client!
    redirect_to @quote, notice: "Ready to send. Copy the client link below."
  rescue ArgumentError => e
    redirect_to @quote, alert: e.message
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:client_id, :title, :tax_rate_bps)
  end
end
