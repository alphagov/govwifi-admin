class RadiusSecretKeyGenerator
  BYTES = 10

  def execute
    SecureRandom.hex(BYTES).upcase
  end
end
