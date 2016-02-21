class PharmaOrdersController < ApplicationController
	def update
	  @order = Order.find(params[:id])

	  params_hash = { order_name: params[:order_name], dosage: params[:dosage] }

	  if params[:status] == "Reject Order"
	  	params_hash[:status] = "draft"
	  else
	  	params_hash[:status] = "completed"
	  end

	  if @order.update(params_hash)
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
end
