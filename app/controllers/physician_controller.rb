class PhysicianController < ApplicationController
	def index
		@draft_orders = Order.where(status: "draft")
		@completed_orders = Order.where(status: "completed")

		if @draft_orders.blank?
			response1 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316024&status=draft",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@draft_orders = get_draft_orders(response1)
		end

		if @completed_orders.blank?
			response2 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationStatement?patient=1316024&_count=3&status=completed",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@completed_orders = get_completed_orders(response2)
		end
	end

	private
	def get_draft_orders(response)
		draft_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: order["resource"]["dosageInstruction"].first["text"] }
			draft_order = Order.new(order_hash, without_protection: true)
			draft_orders << draft_order
			draft_order.save
		end
		draft_orders
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
				dosage: order["resource"]["dosage"].first["text"] }
			completed_order = Order.new(order_hash, without_protection: true)
			completed_orders << completed_order
			completed_order.save
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