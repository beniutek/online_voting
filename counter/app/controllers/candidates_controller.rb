=begin
 Candidates controller is responsible for handling requests made to /votes
 Full API documentation can be found on:
 == {apiary}[https://counter4.docs.apiary.io/]
=end

class CandidatesController < ApiController
  def index
    render json: Candidate.all
  end
end
