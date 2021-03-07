=begin
  This class helps veryfing that the message sent by the voter is correctly signed.
  If that's the case it will mark voter as someone who has voted and prevent him from voting for the second time.
=end

require 'openssl'

class VoteSigner
  #
  # == Parameters:
  # data::
  #  String. This is blinded message from the voter
  # signature::
  #  String. This is signature of the blinded message
  # public_key::
  #  String. This is voter public key
  # voter_id::
  #  String. This is voter unique identificator
  # == Returns:
  # a new VoteSigner instance
  def initialize(data:, signature:, public_key:, voter_id:)
    @data = data
    @pkey = public_key
    @signature = signature
    @voter = Voter.find_by(voter_id: voter_id)
    @rsa ||= OnlineVoting::RSABlindSigner.new
    @admin_key ||= OpenSSL::PKey.read(Administrator.config.online_voting_secret)
  end

  #
  # == Returns:
  # a blinded message signature
  def sign
    validate!

    @voter.update(
      data: @data,
      signature: @signature,
      signed_vote_at: Time.now
    )

    @rsa.sign(message: @data.to_i, key: @admin_key)
  end

  class SignatureValidationError < StandardError
  end

  class ForbiddenToVoteError < StandardError
  end

  private

  def validate!
    raise SignatureValidationError if !data_valid?(@data, @signature, @pkey)
    raise ForbiddenToVoteError if @voter.nil? || !allowed_to_vote?
  end

  def allowed_to_vote?
    @voter.signed_vote_at.nil?
  end

  def data_valid?(data, signature, pkey)
    key = OpenSSL::PKey.read(pkey)
    @rsa.verify(message: data.to_i, signed: signature.to_i, key: key)
  end
end
