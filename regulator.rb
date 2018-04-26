class Regulator
  def initialize(once_every_seconds: 1)
    @once_every_seconds = once_every_seconds
    @time_last_executed = Time.now
  end

  def regulate
    if (Time.now - @time_last_executed).round >= @once_every_seconds
      yield
      @time_last_executed = Time.now
    end
  end
end