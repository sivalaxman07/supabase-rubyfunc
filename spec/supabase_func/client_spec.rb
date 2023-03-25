# frozen_string_literal: true

require "spec_helper"

RSpec.describe SupabaseFunc::Client do
  describe "#setauth" do
    it "updates the authorization header with the given token" do
      client = SupabaseFunc::Client.new("http://localhost:3000")
      client.setauth("my_token")
      expect(client.class.headers["Authorization"]).to eq("Bearer my_token")
    end
  end

  describe "#invoke" do
    let(:client) { SupabaseFunc::Client.new("http://localhost:3000") }

    context "when the request is successful" do
      let(:function_name) { "my_function" }
      let(:options) do
        { headers: { "Content-Type" => "application/json" }, body: { name: "Siva" }.to_json, response_type: "json" }
      end
      let(:response_body) { { message: "Hello, Siva!" } }

      before do
        stub_request(:post, "http://localhost:3000/#{function_name}")
          .with(headers: { "Content-Type" => "application/json" })
          .to_return(status: 200, body: response_body.to_json)
      end

      it "returns the function response" do
        response = client.invoke(function_name, options)
        expect(response).to eq({ data: response_body.to_json, error: nil })
      end
    end

    context "when the request fails" do
      let(:function_name) { "my_function" }
      let(:options) { { headers: { "Content-Type" => "application/json" }, body: { name: "John" }.to_json } }
      let(:response_body) { { message: "Function not found" } }

      before do
        stub_request(:post, "http://localhost:3000/#{function_name}")
          .with(headers: { "Content-Type" => "application/json" })
          .to_return(status: 404, body: response_body.to_json)
      end

      it "returns an error message" do
        response = client.invoke(function_name, options)
        expect(response).to eq({ data: nil, error: "HTTP error 404" })
      end
    end
  end
end
