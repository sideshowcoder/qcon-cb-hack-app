module Utils
  def production?
    ENV["RACK_ENV"] == "production"
  end
end
