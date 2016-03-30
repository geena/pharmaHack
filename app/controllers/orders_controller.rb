require 'uri'
require 'net/http'

class OrdersController < ApplicationController
	def new
		#pull RX norm data here?
	end

	def create
		@order = Order.new(order_params)
    @drug_interaction = ""
    @allergy_interaction = ""

		if params[:order][:image]
			encoded_image = Base64.encode64(params[:order][:image].read)
			@order.image = encoded_image
		end

		@order.order_name = JSON.parse(params[:order][:order_name])["synonym"].to_s

    if @order.order_name.split(" ").first == "Methadose"
		  @drug_interaction = cds_hook
    end

    if @order.order_name.split(" ").first == "Bicillin" && @order.patient_name.strip == "RHEUM, TEST ONE"
        @allergy_interaction = 'Penicillin Allergy for Patient: RHEUM, TEST ONE'
    end

  	 	# in the future, we will post this Order to the EMR
  	    respond_to do |format|
          if !@allergy_interaction.empty? || !@drug_interaction.empty?
              format.html { 
                flash.now[:notice] = [@allergy_interaction, @drug_interaction]
                render action: "new" 
              }
          else
    			    if @order.save
    			        format.html { 
    			        	redirect_to url_for(controller: "physician", action: "index", notice: "Order Created")
    			        }    
    			    else
    			      	format.html { render action: "new" }
    			    end
  	     end
      end
    end

    def cds_hook
      url = URI("https://d1fwjs99ve.execute-api.us-east-1.amazonaws.com/prod/drug-interaction-cds-hook")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["accept"] = 'application/json'
      request["content-type"] = 'application/json'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = '284347e9-3016-53d7-fcd9-bc107006a3e8'
      request.body = "{\"resourceType\":\"Parameters\",\"parameter\":[{\"name\":\"activity\",\"valueCoding\":{\"system\":\"http://cds-hooks.smarthealthit.org/activity\",\"code\":\"medication-prescribe\"}},{\"name\":\"activityInstance\",\"valueString\":\"387c7db2-07d7-4d96-9e5d-06692d9c9c07\"},{\"name\":\"fhirServer\",\"valueUri\":\"http://hooks.smarthealthit.org:9080\"},{\"name\":\"redirect\",\"valueString\":\"http://hooks.fhir.me/service-done.html\"},{\"name\":\"user\",\"valueString\":\"Practitioner/example\"},{\"name\":\"patient\",\"valueId\":\"1288992\"},{\"name\":\"preFetchData\",\"resource\":{\"resourceType\":\"Bundle\",\"type\":\"transaction-response\",\"entry\":[{\"resource\":{\"resourceType\":\"Bundle\",\"type\":\"searchset\",\"total\":5,\"link\":[{\"relation\":\"self\",\"url\":\"http://hooks.smarthealthit.org:9080/?\"}],\"entry\":[{\"fullUrl\":\"http://hooks.smarthealthit.org:9080/MedicationOrder/139\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"id\":\"139\",\"meta\":{\"versionId\":\"98649\",\"lastUpdated\":\"2015-09-16T18:13:10.929-05:00\"},\"text\":{\"status\":\"generated\",\"div\":\"<div>\\n      Lisinopril 20 MG Oral Tablet (rxnorm: 314077)\\n    </div>\"},\"status\":\"active\",\"patient\":{\"reference\":\"Patient/1288992\"},\"medicationCodeableConcept\":{\"coding\":[{\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"314077\",\"display\":\"Lisinopril 20 MG Oral Tablet\"}],\"text\":\"Lisinopril 20 MG Oral Tablet\"},\"dosageInstruction\":[{\"text\":\"1 daily\",\"timing\":{\"repeat\":{\"boundsPeriod\":{\"start\":\"2008-08-13\"},\"frequency\":1,\"period\":1,\"periodUnits\":\"d\"}},\"doseQuantity\":{\"value\":1,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"}}],\"dispenseRequest\":{\"numberOfRepeatsAllowed\":1,\"quantity\":{\"value\":90,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"},\"expectedSupplyDuration\":{\"value\":90,\"unit\":\"days\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"d\"}}},\"search\":{\"mode\":\"match\"}},{\"fullUrl\":\"http://hooks.smarthealthit.org:9080/MedicationOrder/140\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"id\":\"140\",\"meta\":{\"versionId\":\"98695\",\"lastUpdated\":\"2015-09-16T18:13:11.078-05:00\"},\"text\":{\"status\":\"generated\",\"div\":\"<div>\\n      Memantine 10 MG Oral Tablet [Namenda] (rxnorm: 404673)\\n    </div>\"},\"status\":\"active\",\"patient\":{\"reference\":\"Patient/1288992\"},\"medicationCodeableConcept\":{\"coding\":[{\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"404673\",\"display\":\"Memantine 10 MG Oral Tablet [Namenda]\"}],\"text\":\"Memantine 10 MG Oral Tablet [Namenda]\"},\"dosageInstruction\":[{\"text\":\"1 bid\",\"timing\":{\"repeat\":{\"boundsPeriod\":{\"start\":\"2008-08-13\"},\"frequency\":2,\"period\":1,\"periodUnits\":\"d\"}},\"doseQuantity\":{\"value\":1,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"}}],\"dispenseRequest\":{\"numberOfRepeatsAllowed\":1,\"quantity\":{\"value\":180,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"},\"expectedSupplyDuration\":{\"value\":90,\"unit\":\"days\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"d\"}}},\"search\":{\"mode\":\"match\"}},{\"fullUrl\":\"http://hooks.smarthealthit.org:9080/MedicationOrder/141\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"id\":\"141\",\"meta\":{\"versionId\":\"98733\",\"lastUpdated\":\"2015-09-16T18:13:11.204-05:00\"},\"text\":{\"status\":\"generated\",\"div\":\"<div>\\n      donepezil 10 MG Oral Tablet [Aricept] (rxnorm: 153357)\\n    </div>\"},\"status\":\"active\",\"patient\":{\"reference\":\"Patient/1288992\"},\"medicationCodeableConcept\":{\"coding\":[{\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"153357\",\"display\":\"donepezil 10 MG Oral Tablet [Aricept]\"}],\"text\":\"donepezil 10 MG Oral Tablet [Aricept]\"},\"dosageInstruction\":[{\"text\":\"1 qhs\",\"timing\":{\"repeat\":{\"boundsPeriod\":{\"start\":\"2008-08-14\"},\"frequency\":1,\"period\":1,\"periodUnits\":\"d\"}},\"doseQuantity\":{\"value\":1,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"}}],\"dispenseRequest\":{\"numberOfRepeatsAllowed\":1,\"quantity\":{\"value\":90,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"},\"expectedSupplyDuration\":{\"value\":90,\"unit\":\"days\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"d\"}}},\"search\":{\"mode\":\"match\"}},{\"fullUrl\":\"http://hooks.smarthealthit.org:9080/MedicationOrder/142\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"id\":\"142\",\"meta\":{\"versionId\":\"98779\",\"lastUpdated\":\"2015-09-16T18:13:11.356-05:00\"},\"text\":{\"status\":\"generated\",\"div\":\"<div>\\n      Hydrochlorothiazide 50 MG Oral Tablet (rxnorm: 197770)\\n    </div>\"},\"status\":\"active\",\"patient\":{\"reference\":\"Patient/1288992\"},\"medicationCodeableConcept\":{\"coding\":[{\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"197770\",\"display\":\"Hydrochlorothiazide 50 MG Oral Tablet\"}],\"text\":\"Hydrochlorothiazide 50 MG Oral Tablet\"},\"dosageInstruction\":[{\"text\":\"1 daily\",\"timing\":{\"repeat\":{\"boundsPeriod\":{\"start\":\"2008-08-14\"},\"frequency\":1,\"period\":1,\"periodUnits\":\"d\"}},\"doseQuantity\":{\"value\":1,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"}}],\"dispenseRequest\":{\"numberOfRepeatsAllowed\":1,\"quantity\":{\"value\":90,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"},\"expectedSupplyDuration\":{\"value\":90,\"unit\":\"days\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"d\"}}},\"search\":{\"mode\":\"match\"}},{\"fullUrl\":\"http://hooks.smarthealthit.org:9080/MedicationOrder/143\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"id\":\"143\",\"meta\":{\"versionId\":\"98825\",\"lastUpdated\":\"2015-09-16T18:13:11.505-05:00\"},\"text\":{\"status\":\"generated\",\"div\":\"<div>\\n      potassium citrate 10 MEQ Extended Release Tablet (rxnorm: 199381)\\n    </div>\"},\"status\":\"active\",\"patient\":{\"reference\":\"Patient/1288992\"},\"medicationCodeableConcept\":{\"coding\":[{\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"199381\",\"display\":\"potassium citrate 10 MEQ Extended Release Tablet\"}],\"text\":\"potassium citrate 10 MEQ Extended Release Tablet\"},\"dosageInstruction\":[{\"text\":\"1 daily\",\"timing\":{\"repeat\":{\"boundsPeriod\":{\"start\":\"2008-09-30\"},\"frequency\":1,\"period\":1,\"periodUnits\":\"d\"}},\"doseQuantity\":{\"value\":1,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"}}],\"dispenseRequest\":{\"numberOfRepeatsAllowed\":1,\"quantity\":{\"value\":200,\"unit\":\"{tablet}\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{tablet}\"},\"expectedSupplyDuration\":{\"value\":90,\"unit\":\"days\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"d\"}}},\"search\":{\"mode\":\"match\"}}]},\"response\":{\"status\":\"200 OK\"}}]}},{\"name\":\"context\",\"resource\":{\"resourceType\":\"MedicationOrder\",\"dateWritten\":\"2016-03-19\",\"dateEnded\":\"2016-04-19\",\"status\":\"draft\",\"patient\":{\"reference\":\"Patient/1288992\"},\"dosageInstruction\":[{\"doseQuantity\":{\"value\":\"2\",\"system\":\"http://unitsofmeasure.org\",\"code\":\"{pill}\"},\"timing\":{\"repeat\":{\"frequency\":1,\"period\":1,\"periodUnits\":\"d\"}}}],\"medicationCodeableConcept\":{\"text\":\"Methadone Hydrochloride 10 MG Oral Tablet\",\"coding\":[{\"display\":\"Methadone Hydrochloride 10 MG Oral Tablet\",\"system\":\"http://www.nlm.nih.gov/research/umls/rxnorm\",\"code\":\"864706\"}]},\"reasonCodeableConcept\":{\"coding\":[{\"system\":\"http://snomed.info/sct\",\"code\":\"1201005\",\"display\":\"Benign essential hypertension\"}],\"text\":\"Benign essential hypertension\"}}}]}"

      response = http.request(request)
      message = JSON.parse(response.body)["parameter"].first["part"][1]["valueString"]
      message = message.split("**Candidate Medication**")
      current_meds = message.first.split(" - ")
      message = message[1].split("**Interactions**")
      candidate_meds = message.first.split(" - ")
      message = message[1].split("**Disclaimer**")
      interactions = message.first.split(" - ")

      html = "<ul> Current Medications"

      current_meds.each do |med|
        html = html + "<li>#{med}</li>"
      end

      html = html + "</ul> <ul> Candidate Medications"

      candidate_meds.each do |med|
        html = html + "<li>#{med}</li>"
      end

      html = html + "</ul> <ul> Interactions"

      interactions.each do |interaction|
        html = html + "<li>#{interaction}</li>"
      end

      html = html + "</ul>"

      html
    end

    def show
    	@order = Order.find(params[:id])
    end

	def update
	  @order = Order.find(params[:id])

    if params[:order][:image]
      encoded_image = Base64.encode64(params[:order][:image].read)
      params[:order][:image] = encoded_image
    end

	  if @order.update(order_params)
      if params[:order][:care_team] == "physician"
        redirect_to :controller => 'physician', :action => 'index', :notice => "Order Updated"
      elsif params[:order][:care_team] == "nurse"
        redirect_to :controller => 'nurse', :action => 'index', :notice => "Order Updated"
      elsif params[:order][:care_team] == "pharma_tech"
        redirect_to :controller => 'pharma_tech', :action => 'index', :notice => "Order Updated"
      else
	      redirect_to @order
      end
	  else
	    render "edit"
	  end
	end

	def edit
	  @order = Order.find(params[:id])
	end

  private
  def order_params
    params.require(:order).permit(:order_name, :frequency, :patient_name, :status, :dosage, :image, :timestamp, :route)
  end
end
