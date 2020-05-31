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
      bit_commitment: bit_commitment,
      blinded_message: blinded_message,
      blinded_signed_message: blinded_signed_message,
      r: r,
      voter_signature_key: voter_signature_key,
      bit_commitment_key: bit_commitment_key,
      bit_commitment_iv: bit_commitment_iv,
    }
  end

  def to_s
    to_h.to_s
  end
end
