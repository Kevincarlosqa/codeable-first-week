# Methods

def check_empty(input, text, msg = "")
  while input.empty?
    puts msg
    print "#{text}: "
    input = gets.chomp
  end
  input
end

def check_valid_hour(new_input)
  return true if new_input.empty?

  return false if new_input.length != 11

  c1 = new_input[0..1].to_i
  c2 = new_input[3..4].to_i
  c3 = new_input[6..7].to_i
  c4 = new_input[9..10].to_i
  if c1.class != Integer || c2.class != Integer || c3.class != Integer || c4.class != Integer
    return false
  end
  a = new_input[0..1].to_i.between?(0, 24)
  b = new_input[3..4].to_i.between?(0, 59)
  x = new_input[6..7].to_i.between?(0, 24)
  y = new_input[9..10].to_i.between?(0, 59)
  a && b && x && y
end

# Valida si la hora de final es mayor que inicio
def check_correct_hours(new_input)
  return true if new_input.empty?

  a = new_input[0..1].to_i
  b = new_input[3..4].to_i
  x = new_input[6..7].to_i
  y = new_input[9..10].to_i
  (a * 60) + b < (x * 60) + y
end

def check_start_end(input)
  tmp_boolean1 = check_valid_hour(input)
  until tmp_boolean1
    puts "Format: 'HH:MM HH:MM' or leave it empty"
    print "start_end: "
    input = gets.chomp
    tmp_boolean1 = check_valid_hour(input)
  end
  tmp_boolean2 = check_correct_hours(input)
  until tmp_boolean2
    puts "Cannot end before start"
    print "start_end: "
    input = gets.chomp
    tmp_boolean2 = check_correct_hours(input)
  end
  input
end

def update_events(events, id)
  tmp_array = events.select { |event| id == event["id"] }
  puts "Event ID: #{tmp_array[0]['id']}"
  print "date: "
  date = gets.chomp
  date = check_empty(date, "date", "Type a valid date: YYYY-MM-DD")
  print "title: "
  title = gets.chomp
  title = check_empty(title, "title", "Cannot be blank")
  print "calendar: "
  calendar = gets.chomp
  print "start_end: "
  start_end = gets.chomp
  start_end = check_start_end(start_end)
  tmp_string_end = "#{date}T#{start_end[6..10]}:00-05:00"
  if start_end.empty?
    start_end = "00:00 23:59"
    tmp_string_end = ""
  end
  print "notes: "
  notes = gets.chomp
  print "guests: "
  guests = gets.chomp
  tmp_hash = {
    "start_date" => "#{date}T#{start_end[0..4]}:00-05:00",
    "title" => title,
    "end_date" => tmp_string_end,
    "notes" => notes,
    "guests" => guests,
    "calendar" => calendar
  }
  events[events.index(tmp_array[0])].merge!(tmp_hash)
end

def show(events)
  print "Event ID: "
  id = gets.chomp.to_i
  evento_a_mostrar = events.find { |evento| evento["id"] == id }
  dat = evento_a_mostrar["start_date"].split("T")
  puts "date: #{dat[0]}"
  puts "title: #{evento_a_mostrar["title"]}"
  puts "calendar: #{evento_a_mostrar["calendar"]}"
  hora_inicio = evento_a_mostrar["start_date"][11..15]
  hora_termino = evento_a_mostrar["end_date"][11..15]
  unless hora_termino == nil 
    puts "Start_end: #{hora_inicio}-#{hora_termino}"
  else
    puts "Start_end: Es un evento para todo el dia"
  end
  puts "Notes: #{evento_a_mostrar["notes"]}"
  cad = evento_a_mostrar["guests"].join(", ") 
  puts "guests: #{cad}"
end
