module CONFIG
  def self.[](param)
    value = ENV["ZENSLAP_HEROKU_#{param}"]
    raise "ZENSLAP_HEROKU_#{param} must be defined in environment variables" unless value
    value
  end
end