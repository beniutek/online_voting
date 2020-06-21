=begin
  This class is responsible for opening and counting votes send by the voter
  Each vote should be signed by the administrator module
=end
class VoteService
  #
  # == Parameters:
  # signature::
  #  This is the admin signature of the message
  # message::
  #  This is the original message
  def count_vote(signature:, message:)
    if should_be_counted?(message, signature)
      text_msg = rsa.int_to_text(message.to_i)
      vote = Vote.create!(bit_commitment: text_msg, signed_message: signature)
      [true, vote.reload.uuid]
    else
      [false, { signature: has_correct_signature?(message, signature), first_time: voting_first_time?(message, signature) }]
    end
  end

  #
  # == Parameters:
  # uuid::
  #  This is identifier of the vote
  # key::
  #  This is key which was used by the voter to make a bit commitment of the vote
  # iv::
  #  This is the initialization vector used to make the bit commitment
  def open_vote(uuid, key, iv)
    # response = client.get_election_info

    # raise AdminPhaseInProgressError if response['elections']['end'].to_datetime > Time.now

    vote = Vote.find_by(uuid: uuid)

    decrypted = OnlineVoting::Crypto::Message.decrypt(vote.bit_commitment, key, iv)
    json = JSON.parse(decrypted)

    return false unless json['candidate']

    id = json['candidate'].to_i
    candidate = Candidate.find_by(id: id)

    if candidate
      vote.update(decoded: json)
      return true
    else
      return false
    end
  rescue StandardError => e
    puts "Error while parsing vote #{e.message}"
    false
  end

  def should_be_counted?(message, signature)
    has_correct_signature?(message, signature) &&
    voting_first_time?(message, signature)
  end

  def voting_first_time?(bit_commitment, signed_message)
    Vote.where(bit_commitment: bit_commitment).or(Vote.where(signed_message: signed_message)).empty?
  end

  def has_correct_signature?(message, signature)
    rsa.verify(signed: signature.to_i, message: message.to_i, key: Rails.application.config.counter.admin_public_key)
  end

  def all_votes
    Vote.all
  end

  def client
    @client ||= OnlineVoting::AdminClient.new
  end

  def rsa
    @rsa ||= OnlineVoting::RSABlindSigner.new
  end

  class AdminPhaseInProgressError < StandardError
  end
end
