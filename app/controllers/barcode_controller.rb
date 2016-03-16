class BarcodeController < ApplicationController
    def index
    	@order = params[:order]
    	
  		if @order
  			@patient_name = Order.find(params[:order]).patient_name.split(", ").first
  		elsif params[:patient_name].empty?
  			@patient_name = "rheum" 
  		else
  			@patient_name = params[:patient_name].split(", ").first
  		end

	  	@response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?name=#{@patient_name}&_count=20",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]

	    @allergy_response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/AllergyIntolerance?patient=#{@response["id"]}",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]

	    @allergies = @allergy_response.map { |entry| entry["resource"]["substance"]["text"] }
	    @patient = Patient.new(name: @response["name"].first["text"],
	                 dob: @response["birthDate"],
	                 allergies: @allergies)
    end
end
