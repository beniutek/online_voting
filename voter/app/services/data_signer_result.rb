class DataSignerResult < Struct.new(
  :bit_commitment,
  :blinded_message,
  :blinded_signed_message,
  :r,
  :voter_signature_key,
  :bit_commitment_key,
  :bit_commitment_iv)

  def to_h
    {
      bit_commitment: bit_commitment.to_s,
      blinded_message: blinded_message.to_s,
      blinded_signed_message: blinded_signed_message.to_s,
      r: r.to_s,
      voter_signature_key: voter_signature_key.to_s,
      bit_commitment_key: bit_commitment_key.to_s,
      bit_commitment_iv: bit_commitment_iv.to_s,
    }
  end

  def to_s
    to_h.to_s
  end
end
