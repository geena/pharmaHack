class OrdersController < ApplicationController
	def new
		#pull RX norm data here?
	end

	def create
		@order = Order.new(params.require(:order).permit(:order_name, :patient_name, :status, :dosage, :image, :timestamp, :route))

		if params[:order][:image]
			encoded_image = Base64.encode64(params[:order][:image].read)
			@order.image = encoded_image
		end

		@order.order_name = JSON.parse(params[:order][:order_name])['synonym'].to_s

		#@drug_interaction = cds_hook(params)

  	 	# in the future, we will post this Order to the EMR
  	    respond_to do |format|
          if @order.order_name.split(" ").first == "Synthroid" && @order.patient_name == "Regis Philben"
              format.html { 
                flash.now[:notice] = "#{@order.order_name.split(" ").first} Allergy for Patient: #{@order.patient_name}"
                render action: 'new' 
              }
          else
    			    if @order.save
    			        format.html { 
    			        #	render json: @drug_interaction.body
    			        	redirect_to url_for(controller: 'physician', action: 'index', notice: 'Order Created')
    			        }    
    			    else
    			      	format.html { render action: 'new' }
    			    end
  	     end
      end
    end

    def cds_hook(params)
    	HTTParty.post('https://d1fwjs99ve.execute-api.us-east-1.amazonaws.com/prod/drug-interaction-cds-hook', 
    					:verify => false,
				    	:body => post_body(params).to_json,
				    	:headers => { 'Content-Type' => 'application/json;charset=UTF-8',
				    			  	  'Accept' => 'application/json; text/plain' } )
    end

    def post_body(params)
    	"{
  'resourceType': 'Parameters', 
  'parameter': [
    {
      'name': 'activity', 
      'valueCoding': {
        'system': 'http://cds-hooks.smarthealthit.org/activity',
        'code': 'medication-prescribe'
      }
    },
    {
      'name': 'activityInstance', 
      'valueString': '565a1dd3-71b2-4f75-8f55-692fcaaccbf6f'
    }, 
    {
      'name': 'redirect', 
      'valueString': 'https://ehr.example.com/service-done.html'
    },  
    {
      'name': 'context',
      'resource': {
        'status': 'draft', 
        'startDate': '2015-09-18', 
        'patient': {
          'reference': 'Patient/example'
        }, 
        'resourceType': 'MedicationOrder', 
        'dosageInstruction': [
          {
            'doseQuantity': {
              'code': '{pill}', 
              'system': 'https://unitsofmeasure.org', 
              'value': 1
            }, 
            'timing': [
              {
                'repeat': {
                  'periodUnits': 'd', 
                  'frequency': 1, 
                  'period': 1
                }
              }
            ]
          }
        ], 
        'medicationCodeableConcept': {
          'text': 'Ondansetron 4 MG Oral Tablet', 
          'coding': [
            {
              'code': '198052', 
              'display': 'Ondansetron 4 MG Oral Tablet', 
              'system': 'https://www.nlm.nih.gov/research/umls/rxnorm'
            }
          ]
        }, 
        'endDate': '2015-10-18'
      }
    }
  ]
}"
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
