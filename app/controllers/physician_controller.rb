require 'net/http'

class PhysicianController < ApplicationController
	def index
		response1 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316034&status=active", 
			{ verify: false,
				headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
		response2 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316020&status=completed",
			{ verify: false,
				headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
		@active_orders = get_active_orders(response1)
		@completed_orders = get_completed_orders(response2)
	end

	private
	def get_active_orders(response)
		active_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: order["resource"]["dosageInstruction"].first["text"] }
			active_orders << Order.new(order_hash, without_protection: true)
		end
		active_orders
	end

	private
	def get_completed_orders(response)
		completed_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: order["resource"]["dosageInstruction"].first["text"] }
				completed_orders << Order.new(order_hash, without_protection: true)
			end
		completed_orders
	end

	private
	def get_patient(patient_id)
		HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?_id=#{patient_id}", 
			{ verify: false,
				headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]
	end
end