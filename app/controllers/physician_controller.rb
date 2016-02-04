require 'net/http'

class PhysicianController < ApplicationController
  def index
  	response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=2744010&status=active%2Cdraft", 
  							{ verify: false,
  							  headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
	@prescriptions = []
	response.each do |prescription|
		@prescriptions << { name: prescription["resource"]["contained"].first["name"],
							status: prescription["resource"]["status"],
							dosage: prescription["resource"]["dosageInstruction"].first["text"] }
	end
  end
end
