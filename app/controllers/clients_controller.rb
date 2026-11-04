class ClientsController < ApplicationController
  def index
    @clients = Client.order(:name)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to new_quote_path(client_id: @client.id), notice: "#{@client.name} added. Now start their quote."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :company)
  end
end
