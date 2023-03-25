require 'httparty'

module SupabaseFunc
  class FunctionsClient
    include HTTParty

    def initialize(url, headers = {})
      @base_url = url
      self.class.headers(headers)
    end
    
    def set_auth(token)
      # Updates the authorization header
      # Parameters
      # ----------
      # token : str
      # he new jwt token sent in the authorization header
      self.class.headers('Authorization' => "Bearer #{token}")
    end

    def invoke(function_name, invoke_options)
      # Invokes a function
      # Parameters
      # ----------
      # function_name : the name of the function to invoke
      # invoke_options : object with the following properties
      # `headers`: object representing the headers to send with the request
      # `body`: the body of the request
      # `response_type`: how the response should be parsed. The default is `json`
      # Returns
      # -------
      # Hash with data and/or error message
      headers = invoke_options.fetch(:headers, {})
      body = invoke_options[:body]
      response_type = invoke_options.fetch(:response_type, 'json')

      url = "#{@base_url}/#{function_name}"
      headers['Content-Type'] ||= 'application/json'

      begin
        response = HTTParty.post(url, headers: headers, body: body)
        if response.success?
          data = response_type == 'json' ? response.parsed_response : response.body
          { data: data, error: nil }
        elsif response.headers['x-relay-header'] == 'true'
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