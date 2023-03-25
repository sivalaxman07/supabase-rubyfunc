require 'spec_helper'

RSpec.describe SupabaseFunc::FunctionsClient do
  describe '#set_auth' do
    it 'updates the authorization header with the given token' do
      client = SupabaseFunc::FunctionsClient.new('http://localhost:3000')
      client.set_auth('my_token')
      expect(client.class.headers['Authorization']).to eq('Bearer my_token')
    end
  end

  describe '#invoke' do
    let(:client) { SupabaseFunc::FunctionsClient.new('http://localhost:3000') }

    context 'when the request is successful' do
      let(:function_name) { 'my_function' }
      let(:invoke_options) { { headers: { 'Content-Type' => 'application/json' }, body: { name: 'Siva' }.to_json ,response_type: 'json'} }
      let(:response_body) { { message: 'Hello, Siva!' } }

      before do
        stub_request(:post, "http://localhost:3000/#{function_name}")
          .with(headers: { 'Content-Type' => 'application/json' })
          .to_return(status: 200, body: response_body.to_json)
      end

      it 'returns the function response' do
        response = client.invoke(function_name, invoke_options)
        expect(response).to eq({ data: response_body.to_json, error: nil })
      end
    end

    context 'when the request fails' do
      let(:function_name) { 'my_function' }
      let(:invoke_options) { { headers: { 'Content-Type' => 'application/json' }, body: { name: 'John' }.to_json } }
      let(:response_body) { { message: 'Function not found' } }

      before do
        stub_request(:post, "http://localhost:3000/#{function_name}")
          .with(headers: { 'Content-Type' => 'application/json' })
          .to_return(status: 404, body: response_body.to_json)
      end

      it 'returns an error message' do
        response = client.invoke(function_name, invoke_options)
        expect(response).to eq({ data: nil, error: 'HTTP error 404' })
      end
    end
  end
end
