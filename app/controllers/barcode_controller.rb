class BarcodeController < ApplicationController
    def patient
  		if params[:patient_name].empty?
  			@patient_name = "rheum" 
  		else
  			@patient_name = URI.escape(params[:patient_name].strip)
  			puts @patient_name
  		end

	  	@response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?name=#{@patient_name}&_count=20",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]

	    @allergy_response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/AllergyIntolerance?patient=#{@response["id"]}",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]

	    @allergies = @allergy_response ? @allergy_response.map { |entry| entry["resource"]["substance"]["text"] } : []
	    @patient = Patient.new(name: @response["name"].first["text"],
	                 dob: @response["birthDate"],
	                 allergies: @allergies)
    end
end
