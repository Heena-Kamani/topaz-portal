class LineItemsController < ApplicationController
  before_action :set_quote

  def create
    @line_item = @quote.line_items.build(line_item_params)
    @line_item.position = @quote.line_items.maximum(:position).to_i + 1

    if @line_item.save
      redirect_to @quote
    else
      redirect_to @quote, alert: @line_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    line_item = @quote.line_items.find(params[:id])
    if line_item.destroy
      redirect_to @quote
    else
      redirect_to @quote, alert: line_item.errors.full_messages.to_sentence
    end
  end

  private

  def set_quote
    @quote = Quote.find(params[:quote_id])
  end

  def line_item_params
    params.require(:line_item).permit(:description, :quantity, :unit_price)
  end
end
