=begin
 Results controller is responsible for handling requests made to /votes
 Full API documentation can be found on:
 == {apiary}[https://counter4.docs.apiary.io/]
=end

class ResultsController < ApiController
  def index
    if true
      render json: Result.get_results
    else
      render json: { error: 'voting still in progress' }, status: :bad_request
    end
  end
end
