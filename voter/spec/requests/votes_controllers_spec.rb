require 'rails_helper'

RSpec.describe "VotesControllers", type: :request do
  let(:headers) {{ 'Content-Type' => 'application/json'}}
  describe "POST /sign" do
    subject { response }

    before do
      allow_any_instance_of(DataSigner).to receive(:sign_vote).and_return(sign_result)
      allow_any_instance_of(DataSigner).to receive(:unblind_message).and_return(unblind_result)
      allow_any_instance_of(CounterClient).to receive(:send_vote).and_return(counter_result)
      post votes_path, params: params, headers: headers
    end

    let(:params) {{
      data: {
        message: { candidate: 4 },
        id: SecureRandom.uuid,
      }
    }.to_json }

    let(:sign_result) { DataSignerResult.new }
    let(:unblind_result) { true }
    let(:counter_result) {{ "index" => true }}

    context "params are ok" do
      it { is_expected.to have_http_status :ok }
    end

    context "one of the params is missing" do
      let(:params) {{
        data: {
          message: { candidate: 4 },
          id: nil,
        }
      }.to_json }

      it { is_expected.to have_http_status :bad_request }
    end

    context "data signer returns and error" do
      before do
        allow_any_instance_of(DataSigner).to receive(:sign_vote).and_raise(DataSigner::AdminSignatureError)
        post votes_path, params: params, headers: headers
      end
      it { is_expected.to have_http_status :bad_request }
    end

    context "counter client returns and error" do
      before do
        allow_any_instance_of(CounterClient).to receive(:send_vote).and_raise(CounterClient::CounterClientError)
        post votes_path, params: params, headers: headers
      end
      it { is_expected.to have_http_status :bad_request }
    end
  end
end
