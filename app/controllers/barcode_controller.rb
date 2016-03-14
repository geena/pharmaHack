class BarcodeController < ApplicationController
  def index
	  	@response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?name=rheum&_count=1",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]

	     @allergy_response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/AllergyIntolerance?patient=2744010",
	            { verify: false,
	              headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]

	    @allergies = @allergy_response.map { |entry| entry["resource"]["substance"]["text"] }
	    @patient = Patient.new(name: @response["name"].first["text"],
	                 dob: @response["birthDate"],
	                 allergies: @allergies)
	    @patient
  end
end
