module ScoresHelper
  def format_time(time)
    if time < 60
      "00:#{"%02d" % time}"
    else
      arr = []
      until time == 0
        arr << time % 60
        time /= 60
      end
      arr.reverse
          .map { |n| "%02d" % n }
          .join(":")
    end
  end
end
