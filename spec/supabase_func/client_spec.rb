require "httpx"

RSpec.describe SupabaseFunc::FunctionsClient do
  let(:url) { "https://supabase.com" }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:client) { SupabaseFunc::FunctionsClient.new(url, headers) }

  describe "#set_auth" do
    it "updates the authorization header with the given token" do
      token = "mytoken"
      client.set_auth(token)
      expect(client.instance_variable_get(:@headers)["Authorization"]).to eq("Bearer #{token}")
    end
  end

  describe '#invoke' do
    let(:function_name) { 'docs' }
    
    context 'when the request is successful' do
      let(:invoke_options) { { headers: {}, body: {} } }
      let(:response_body) { { message: 'Hello, world!' } }
      
      before do
        stub_request(:post, "http://localhost:3000/functions/#{function_name}")
          .with(headers: { 'Content-Type' => 'application/json' })
          .to_return(status: 200, body: response_body.to_json)
      end
      
      it 'returns the function response' do
        result = client.invoke(function_name, invoke_options)
        expect(result[:data]).to eq(response_body)
        expect(result[:error]).to be_nil
      end
    end
    
    context 'when the request fails' do
      let(:invoke_options) { { headers: {}, body: {} } }
      let(:response_body) { { error: 'Function not found' } }
      
      before do
        stub_request(:post, "http://localhost:3000/functions/#{function_name}")
          .with(headers: { 'Content-Type' => 'application/json' })
          .to_return(status: 404, body: response_body.to_json)
      end
      
      it 'returns an error message' do
        result = client.invoke(function_name, invoke_options)
        expect(result[:data]).to be_nil
        expect(result[:error]).to eq('HTTP error 404')
      end
    end
  end
end
