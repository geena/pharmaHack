class OrdersController < ApplicationController
	def new
		#pull RX norm data here?
	end

	def create
		@order = Order.new(params.require(:order).permit(:order_name, :patient_name, :status, :dosage, :image))

		if params[:image]
			encoded_image = Base64.encode64(params[:image].read)
			@order.image = encoded_image
		end

	 	# in the future, we will post this Order to the EMR
	    respond_to do |format|
	    if @order.save
	        format.html { redirect_to url_for(controller: "physician", action: "index", notice: "Order created.")}    
	    else
	      	format.html { render action: "new" }
	    end
	  end
    end

    def show
    	@order = Order.find(params[:id])
    end

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
end
