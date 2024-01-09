# frozen_string_literal: true

class TicketsController < ApplicationController
  def index
    @tickets = @current_user.tickets
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      format.html { redirect_to ticket_url(@ticket), notice: 'Ticket was successfully created.' } if @ticket.save
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:type, :base_price, :quantity)
  end
end
