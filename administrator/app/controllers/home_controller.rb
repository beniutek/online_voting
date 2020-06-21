=begin
 Home controller is responsible for handling requests made to administrator module
 Full API documentation can be found on:
 == {apiary}[https://admin58.docs.apiary.io/]
=end

class HomeController < ApplicationController
  #
  # == Params:
  # doesn't need any
  #
  def public_key
    render json: { key: Administrator.config.public_key }
  end

  #
  # == Params:
  # doesn't need any
  #
  def phase
    render json: {
      elections: {
        admin_phase: admin_phase_finished?
      }
    }
  end
end
