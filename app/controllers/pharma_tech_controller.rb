class PharmaTechController < ApplicationController
	def index
		@Admin_menu = Hash.new
		@Admin_menu["Order Workstation"] = physician_inflight_path
		@Admin_menu["Review Orders"] = physician_inreview_path
		@Admin_menu["Pharmacy"] = pharma_tech_index_path
		@Admin_menu["Administration"] = nurse_index_path

		@active_orders = Order.where(status: "active")

		if @active_orders.blank?
			response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316034&status=active",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@active_orders = get_active_orders(response)
		end
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
			active_order = Order.new(order_hash, without_protection: true)
			active_orders << active_order
			active_order.save
		end
		active_orders
	end

	private
	def get_patient(patient_id)
		HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/Patient?_id=#{patient_id}", 
			{ verify: false,
				headers: { 'Accept' => 'application/json' } }).parsed_response["entry"].first["resource"]
	end
end
