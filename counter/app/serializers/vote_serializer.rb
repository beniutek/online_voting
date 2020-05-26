class VoteSerializer < CustomSerializer
  attributes :uuid, :bit_commitment, :signed_message
end
