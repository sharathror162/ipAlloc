require_relative '../../lib/csv_loader'
require 'json'

class DevicesController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :validate_ip, only: [:get_ip_address]
  before_action :get_response_body, :check_existing_ip, only: [:assign_ip_address]

  @@file_path = IpTracker::Application.config.IPALLOC_DATAPATH

  def get_ip_address
    device_name = CsvLoader.new.load_from_csv!(params[:address], @@file_path)

     if device_name
      build_success_ip_json(params[:address], device_name, "ok")
     else
      error_msg(params[:address], "not_found")
     end
  end

  def assign_ip_address
    CsvLoader.new.write_to_csv!(@ip, @device, @@file_path)
    build_success_ip_json(@ip, @device, "created") 
  end

    private

      def validate_ip
        valid_ip_format = /\A1.2+\.[0-9]{1,3}+\.[0-9]{1,3}\z/
    
        unless params[:address] =~ valid_ip_format
          error_msg(params[:address], "bad_request") and return
        end
      end

      def check_existing_ip
        csv_rows = CsvLoader.new.read_from_csv!(@@file_path)
        error_msg(@ip, "conflict") if csv_rows.flatten.include?(@ip)
      end

      def error_msg(ip, msg)
        error_hash = {:error => msg.humanize, :ip => ip}
        render json: error_hash, status: msg.to_sym and return
      end

      def build_success_ip_json(ip, device_name, msg)
        json_hash = {:device => device_name, :ip => ip }
        render json: json_hash, status: msg.to_sym and return
      end

      def get_response_body
        body = request.body.read()
        parsed_body = JSON.parse(body)
        @device = parsed_body["device"]
        @ip = parsed_body["ip"]
      end

end
