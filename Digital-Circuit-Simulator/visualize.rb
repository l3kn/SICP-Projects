class Probe
  def initialize
    @initial = 0
    @values = {}
  end

  def add_value(time, value)
    @values[time] = value
  end

  def get_value(time)
    key = @values.keys.select{ |k| k <= time }.max
    @values[key]
  end

  def visualize(max_time, low_symbol="0", high_symbol="1", join_symbol=" ")
    (0..max_time).map { |t| get_value(t) == 0 ? low_symbol : high_symbol }.
                  join(join_symbol)
  end
end

max_time = 0
signals = {}
comments = {}

while line = gets
  time, name, value = line.split("\t")
  time = time.to_i

  if name == "COMMENT"
    comments[time] = value
  else
    unless signals.has_key?(name)
      signals[name] = Probe.new
    end

    signals[name].add_value(time, value.to_i)
  end
  max_time = time
end

max_length = signals.keys.map(&:length).max

signals.each do |name, signal|
  print "#{name.rjust(max_length, ' ')}: "
  puts signal.visualize(max_time, "…", "#", "")
end

comments.each do |time, comment|
  print " " * (max_length + 2 + time)
  puts "^ #{comment}"
end
