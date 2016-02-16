class PharmaTechController < ApplicationController
  def index
 	response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316034&status=active",
				{ verify: false,
				  headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
  end
end
