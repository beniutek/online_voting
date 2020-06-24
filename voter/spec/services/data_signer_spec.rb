require 'rails_helper'

RSpec.describe DataSigner do
  before do
    allow(mock_client).to receive(:new).and_return(mock_client_instance)
  end

  let(:mock_client) { double('client') }
  let(:mock_client_instance) { double('client_instance') }
  let(:data_signer) { described_class.new(private_key: voter_key.to_s, admin_client: mock_client) }
  let(:message) {{ candidate: 4 }}
  let(:voter_id) { SecureRandom.uuid }
  let!(:rsa) { OnlineVoting::RSABlindSigner.new }
  let!(:voter_key) { OpenSSL::PKey::RSA.new(512) }
  let!(:admin_key) { OpenSSL::PKey::RSA.new(512) }
  let!(:bc_iv) { OpenSSL::Cipher::AES256.new.random_iv }
  let!(:bc_key) { SecureRandom.hex(16) }
  let(:r) { blinding_result[1] }

  let(:encrypted_message) { OnlineVoting::Crypto::Message.encrypt(message.to_json, bc_key, bc_iv)[0] }
  let(:encoded_encrypted_message) { Base64.encode64(encrypted_message) }
  let(:blinding_result) { rsa.blind(encoded_encrypted_message, admin_key.public_key) }
  let(:blinded_encoded_encrypted_message) { blinding_result[0] }
  let(:signed_by_admin_blinded_encoded_encrypted_message) { rsa._sign(blinded_encoded_encrypted_message, admin_key) }

  describe '#sign_vote' do
    let(:admin_response) {{ "data" => { "admin_signature" => signed_by_admin_blinded_encoded_encrypted_message }}}

    before do
      allow(mock_client_instance).to receive(:get_admin_public_key).and_return(admin_key.public_key.to_s)
      allow(mock_client_instance).to receive(:get_admin_signature).and_return(admin_response)
    end

    context "admin signature is incorrect" do
      it "returns an error object" do
        expect { data_signer.sign_vote(message, voter_id, bc_key, bc_iv) }.to raise_error(DataSigner::AdminSignatureError)
      end
    end
  end
end
