module Counter
  extend self

  def config
    Rails.application.config.counter
  end
end
