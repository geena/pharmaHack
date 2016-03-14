class NurseController < ApplicationController
  def index
  	@approved_orders = Order.where(status: "approved")

	if @approved_orders.blank?
		response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316020&status=completed&_count=5",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
		@approved_orders = get_approved_orders(response)
	end
  end

	private
	def get_approved_orders(response)
		approved_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			dosage_instruction = order["resource"]["dosageInstruction"].first
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: "approved",
				dosage: dosage_instruction["text"],
				route: dosage_instruction["route"] ? dosage_instruction["route"]["text"] : "",
				timestamp: dosage_instruction["scheduledTiming"]["repeat"]["bounds"]["start"] }
			approved_order = Order.new(order_hash, without_protection: true)
			approved_orders << approved_order
			approved_order.save
		end
		approved_orders
	end

		private
	def get_patient(patient_id)
		HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?_id=#{patient_id}", 
			{ verify: false,
				headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]
	end
end
