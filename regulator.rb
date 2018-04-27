class Regulator
  def initialize(once_every_seconds: 1)
    @once_every_seconds = once_every_seconds
    @time_last_executed = Time.now.to_i
  end

  def regulate
    if (Time.now.to_i - @time_last_executed) >= @once_every_seconds
      @time_last_executed = Time.now.to_i
      yield
    end
  end
end