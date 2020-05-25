class VoteService
  def initialize(client: OnlineVoting::AdminClient.new)
    @client = client
  end

  def count_vote(signature:, message:)
    if should_be_counted?(message, signature)
      vote = Vote.create!(bit_commitment: message, signed_message: signature)
      [true, vote.reload.uuid]
    else
      [false, { signature: has_correct_signature?(message, signature), first_time: voting_first_time?(message, signature) }]
    end
  end

  def open_vote(uuid, key)
    vote = Vote.find_by(uuid: uuid)
  end

  def should_be_counted?(message, signature)
    has_correct_signature?(message, signature) &&
    voting_first_time?(message, signature)
  end

  def voting_first_time?(bit_commitment, signed_message)
    Vote.where(bit_commitment: bit_commitment).or(Vote.where(signed_message: signed_message)).empty?
  end

  def has_correct_signature?(message, signature)
    rsa.verify(signed: signature.to_i, message: rsa.text_to_int(message), key: Rails.application.config.counter.admin_public_key)
  end

  def rsa
    @rsa ||= OnlineVoting::RSABlindSigner.new
  end

  def all_accounted_for_votes
    admin_repsonse = JSON.parse(@client.admin_voters_list)
    admin_registered_votes = admin_response["data"].size

    if Counter.config.strict_votes_count
      return Voter.count == admin_registered_votes
    else
      return Voter.count <= admin_registered_votes
    end
  end
end
