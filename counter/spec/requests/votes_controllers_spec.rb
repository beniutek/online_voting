require 'rails_helper'

RSpec.describe "VotesControllers", type: :request do
  let(:headers) {{ 'Content-Type' => 'application/json'}}

  describe "POST /sign" do
    subject { response }

    before do
      allow_any_instance_of(VoteService).to receive(:count_vote).and_return(count_result)
      post votes_path, params: params, headers: headers
    end

    let(:params) {{
      signed_message: 'signed message',
      bit_commitment: 'bit c',
    }.to_json }

    let(:count_result) { [true, 2] }
    context "params are ok" do
      it { is_expected.to have_http_status :ok }
    end

    context "one of the params is missing" do
      let(:params) {{
        signed_message: nil,
        bit_commitment: 'bit c',
      }.to_json }

      it { is_expected.to have_http_status :bad_request }
    end

    context "vote service returns an error" do
      let(:count_result) { [false, 2] }
      it { is_expected.to have_http_status :bad_request }
    end
  end

  describe "POST /open" do
    subject { response }

    before do
      allow_any_instance_of(VoteService).to receive(:open_vote).and_return(open_result)
      post open_vote_path(id), params: params, headers: headers
    end

    let(:id) { '33' }
    let(:params) {{ data: {
      iv: 'signed message',
      key: 'bit c',
      r: 'r',
    }}.to_json }
    let(:open_result) { true }

    context "params are ok" do
      it { is_expected.to have_http_status :ok }
    end

    context "one of the params is missing" do
      let(:params) {{}.to_json }

      it { is_expected.to have_http_status :bad_request }
    end

    context "vote service returns an error" do
      let(:open_result) { false }
      it { is_expected.to have_http_status :bad_request }
    end
  end

  describe "GET /votes" do
    before do
      allow_any_instance_of(OnlineVoting::AdminClient).to receive(:get_election_info).and_return({ "elections" => { "admin_phase" => false } })
      allow_any_instance_of(VoteService).to receive(:all_votes).and_return(all_votes)
      get votes_path, headers: headers
    end

    let(:all_votes) { 3.times { Vote.create! }; Vote.all }

    context "status" do
      subject { response }
      it { is_expected.to have_http_status :ok }
    end
  end
end
