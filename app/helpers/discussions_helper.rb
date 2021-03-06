module DiscussionsHelper

  # Show 'time since' in a user friendly way
  def time_ago(time)
    if Time.now < time || Time.now - time > 1.day
      l(time.in_time_zone('CET'), format: :short)
    else
      time_ago_in_words(time) + ' ' + t('datetime.ago')
    end
  end

end
