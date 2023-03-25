# frozen_string_literal: true

require "httparty"

module SupabaseFunc
  class Client
    include HTTParty

    def initialize(url, headers = {})
      @base_url = url
      self.class.headers(headers)
    end

    def setauth(token)
      # Updates the authorization header
      # Parameters
      # ----------
      # token : str
      # he new jwt token sent in the authorization header
      self.class.headers("Authorization" => "Bearer #{token}")
    end

    def invoke(function_name, options)
      # Invokes a function
      # Parameters
      # ----------
      # function_name : the name of the function to invoke
      # options : hash with the following properties
      # `headers`: hash representing the headers to send with the request
      # `body`: the body of the request
      # `response_type`: how the response should be parsed. The default is `json`
      # Returns
      # -------
      # Hash with data and/or error message
      headers = options.fetch(:headers, {})
      body = options[:body]
      response_type = options.fetch(:response_type, "json")

      url = "#{@base_url}/#{function_name}"
      headers["Content-Type"] ||= "application/json"

      begin
        response = HTTParty.post(url, headers: headers, body: body)
        if response.success?
          data = response_type == "json" ? response.parsed_response : response.body
          { data: data, error: nil }
        elsif response.headers["x-relay-header"] == "true"
          { data: nil, error: response.body }
        else
          { data: nil, error: "HTTP error #{response.code}" }
        end
      rescue StandardError => e
        { data: nil, error: e.message }
      end
    end
  end
end
