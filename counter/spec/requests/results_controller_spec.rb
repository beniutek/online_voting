require 'rails_helper'

RSpec.describe "VotesControllers", type: :request do
  let(:headers) {{ 'Content-Type' => 'application/json'}}

  describe "GET /results" do
    let(:results) { Result.create(result: { "Candidate 1" => 44, "Candidate 2" => 123456 }) }

    describe 'when admin phase is finished' do
      before do
        allow_any_instance_of(OnlineVoting::AdminClient).to receive(:get_election_info).and_return({ "elections" => { "admin_phase" => false } })
        get results_path, headers: headers
      end

      context "status" do
        subject { response }
        it { is_expected.to have_http_status :ok }
      end
    end

    describe 'when admin phase is finot yet nished' do
      before do
        allow_any_instance_of(OnlineVoting::AdminClient).to receive(:get_election_info).and_return({ "elections" => { "admin_phase" => true } })
        get results_path, headers: headers
      end

      context "status" do
        subject { response }
        it { is_expected.to have_http_status :bad_request }
      end
    end
  end
end
