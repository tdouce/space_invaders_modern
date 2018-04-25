class StopWatch
  def self.time(seconds, idempotency_key: nil, after_timer: nil)
    idempotency_key = idempotency_key.to_s.delete(' ')

    display_for_seconds_instance_var = "@display_for_seconds_#{ idempotency_key }".to_sym
    display_for_seconds = instance_variable_get(display_for_seconds_instance_var) ||
      instance_variable_set(display_for_seconds_instance_var, seconds)

    time_start_instance_var = "@time_start_#{ idempotency_key }".to_sym
    time_start = instance_variable_get(time_start_instance_var) ||
      instance_variable_set(time_start_instance_var, Time.now)

    if (Time.now - time_start).round <= display_for_seconds
      yield
    elsif after_timer && ((Time.now - time_start).round > display_for_seconds)
      after_timer.call
    end
  end
end