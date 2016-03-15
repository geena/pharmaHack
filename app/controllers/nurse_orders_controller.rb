class NurseOrdersController < ApplicationController
	def update
	  @order = Order.find(params[:id])

	  if @order.update(order_params)
	    redirect_to @order
	  else
	    render 'edit'
	  end
	end

	def edit
	  @order = Order.find(params[:id])
	end

	def show
    	@order = Order.find(params[:id])
    end

	private
	 def order_params
	   params.require(:order).permit(:order_name, :patient_name, :status, :dosage, :image, :timestamp, :route)
	end
end
