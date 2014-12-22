module DistrictsHelper

  # Turns number of milliseconds since epoch to Time and prints it
  def mseconds_since_epoch_to_time(mseconds)
    Time.at(mseconds.to_i / 1000).strftime('%d.%m.%Y')
  end

end
