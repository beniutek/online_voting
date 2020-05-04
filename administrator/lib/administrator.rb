module Administrator
  extend self

  def config
    Rails.application.config.administrator
  end
end
