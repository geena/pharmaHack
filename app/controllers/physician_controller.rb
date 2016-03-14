class PhysicianController < ApplicationController
	def index
		@draft_orders = Order.where(status: "draft")
		@active_orders = Order.where(status: "active")
		@approved_orders = Order.where(status: "approved")
		@completed_orders = Order.where(status: "completed")

		if @draft_orders.blank?
			response1 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316024&status=draft",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@draft_orders = get_draft_orders(response1)
		end

		if @active_orders.blank?
			response = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316034&status=active",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@active_orders = get_active_orders(response)
		end

		if @approved_orders.blank?
			response3 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationPrescription?patient=1316020&status=completed&_count=5",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@approved_orders = get_approved_orders(response3)
		end

		if @completed_orders.blank?
			response4 = HTTParty.get("https://fhir-open.sandboxcernerpowerchart.com/may2015/d075cf8b-3261-481d-97e5-ba6c48d3b41f/MedicationStatement?patient=1316024&_count=3&status=completed",
				{ verify: false,
					headers: { 'Accept' => 'application/json' } }).parsed_response["entry"]
			@completed_orders = get_completed_orders(response4)
		end
	end

	private
	def get_draft_orders(response)
		draft_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			dosage_instruction = order["resource"]["dosageInstruction"].first
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: dosage_instruction["text"],
				route: dosage_instruction["route"] ? dosage_instruction["route"]["text"] : "",
				timestamp: dosage_instruction["scheduledTiming"]["repeat"]["bounds"]["start"] }
			draft_order = Order.new(order_hash, without_protection: true)
			draft_orders << draft_order
			draft_order.save
		end
		draft_orders
	end

	private
	def get_active_orders(response)
		active_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			dosage_instruction = order["resource"]["dosageInstruction"].first
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: dosage_instruction["text"],
				route: dosage_instruction["route"] ? dosage_instruction["route"]["text"] : "",
				timestamp: dosage_instruction["scheduledTiming"]["repeat"]["bounds"]["start"] }
			active_order = Order.new(order_hash, without_protection: true)
			active_orders << active_order
			active_order.save
		end
		active_orders
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
	def get_completed_orders(response)
		completed_orders = []
		response.each do |order|
			patient_id = order["resource"]["patient"]["reference"].split("/").last
			patient = get_patient(patient_id)
			dosage = order["resource"]["dosage"].first
			order_hash = { patient_name: patient["name"].first["text"],
				image: patient["photo"].first["data"],
				order_name: order["resource"]["contained"].first["name"],
				status: order["resource"]["status"],
				dosage: dosage["text"],
				timestamp: order["resource"]["effectivePeriod"]["start"],
				route: dosage["route"] ? dosage["route"]["text"] : "" }
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