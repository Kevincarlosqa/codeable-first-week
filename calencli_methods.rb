# Methods

def check_empty(input, text, msg = "")
  while input.empty?
    puts msg
    print "#{text}: ".colorize(:light_cyan)
    input = gets.chomp
  end
  input
end

def check_valid_hour(new_input)
  return true if new_input.empty?

  return false if new_input.length != 11

  c1 = new_input[0..1]
  c2 = new_input[3..4]
  c3 = new_input[6..7]
  c4 = new_input[9..10]
  return false if c1.match?(/[a-zA-Z]/) || c2.match?(/[a-zA-Z]/) || c3.match?(/[a-zA-Z]/) || c4.match?(/[a-zA-Z]/)

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
    print "start_end: ".colorize(:light_cyan)
    input = gets.chomp
    tmp_boolean1 = check_valid_hour(input)
  end
  tmp_boolean2 = check_correct_hours(input)
  until tmp_boolean2
    puts "Cannot end before start"
    print "start_end: ".colorize(:light_cyan)
    input = gets.chomp
    tmp_boolean2 = check_correct_hours(input)
  end
  input
end

def show(events)
  print "Event ID: ".colorize(:light_cyan)
  id = gets.chomp
  while id.empty?
    puts "Cannot be blank"
    print "Event ID: ".colorize(:light_cyan)
    id = gets.chomp
  end
  id = id.to_i
  evento_a_mostrar = events.find { |evento| evento["id"] == id }
  while evento_a_mostrar.nil?
    puts "Invalid ID"
    print "Event ID: ".colorize(:light_cyan)
    id = gets.chomp.to_i
    evento_a_mostrar = events.find { |evento| evento["id"] == id }
  end
  array_date = evento_a_mostrar["start_date"].split("T")
  print "date: ".colorize(:light_cyan)
  puts array_date[0].to_s
  print "title: ".colorize(:light_cyan)
  puts evento_a_mostrar["title"].to_s
  print "calendar: ".colorize(:light_cyan)
  puts evento_a_mostrar["calendar"].to_s
  hora_inicio = evento_a_mostrar["start_date"][11..15]
  hora_termino = evento_a_mostrar["end_date"][11..15]
  print "Start_end: ".colorize(:light_cyan)
  if hora_termino.nil?
    puts "Es un evento para todo el dia"
  else
    puts "#{hora_inicio} #{hora_termino}"
  end
  print "Notes: ".colorize(:light_cyan)
  puts evento_a_mostrar["notes"].to_s
  cad = evento_a_mostrar["guests"].join(", ")
  print "guests: ".colorize(:light_cyan)
  puts cad.to_s
  print $menu.colorize(:light_cyan)
end

def delete_event(events)
  print "Event ID: ".colorize(:light_cyan)
  id = gets.chomp
  while id.empty?
    puts "Cannot be blank"
    print "Event ID: ".colorize(:light_cyan)
    id = gets.chomp
  end
  id = id.to_i
  index_delete = events.find_index { |event| event["id"] == id }
  while index_delete.nil?
    puts "Event not found"
    print "Event ID: ".colorize(:light_cyan)
    id = gets.chomp.to_i
    index_delete = events.find_index { |event| event["id"] == id }
  end
  events.delete_at(index_delete)
  puts "Event deleted"
end

def hash_color(input_hash)
  tipo_calendario = input_hash["calendar"]
  case tipo_calendario
  when "english"
    :magenta
  when "web-dev"
    :red
  when "soft-skills"
    :green
  when "default"
    :default
  else
    :light_gray
  end
end

# Método que ordena un array de hashes por un value
def sort_array_hashes(array_of_hashes, sort_by)
  array_of_hashes.sort_by! { |hsh| hsh[sort_by] }
end

def list(events, date = DateTime.now, msg = "")
  tmp_date = date - (date.strftime("%u").to_i - 1) # Lunes de esta fecha
  puts "#{'-' * 29}#{msg}#{'-' * 30}".colorize(:light_cyan)
  puts ""
  7.times do
    print "#{tmp_date.strftime('%a')} #{tmp_date.strftime('%b')} #{tmp_date.strftime('%d')}  " # Calendario
    # Almacena en un array los eventos cuyo dia sea igual al que se esta imprimiendo
    tmp_events = events.select { |event| tmp_date === Date.parse(event["start_date"]) }
    all_day_events = [] # Array para los eventos de todo el día
    start_end_events = [] # Array para los eventos con hora de inicio y fin
    if tmp_events.empty? # Si no encontró eventos realiza lo siguiente
      puts "              No events"
    else
      tmp_events.each do |tmp_event| # Busca y agrega a 2 array los eventos que no tienen end_date y que tienen end date
        if tmp_event["end_date"] == ""
          all_day_events.push(tmp_event)
        else
          start_end_events.push(tmp_event)
        end
      end
      sort_array_hashes(start_end_events, "start_date") # Ordena el array de hashes que tienen end_date
      if all_day_events.empty? # Si no hay elementos que tienen end_date realiza lo siguiente
        m = 1
        start_end_events.each do |start_end_event| # Empieza a imprimir todos los elementos que tienen end_date
          color = hash_color(start_end_event)
          if m == 1
            print "#{start_end_event['start_date'][11..15]} - #{start_end_event['end_date'][11..15]} ".colorize(color)
            print "#{start_end_event['title']} ".colorize(color)
            puts "(#{start_end_event['id']})".colorize(color)
            m = 2
          else
            print "            "
            print "#{start_end_event['start_date'][11..15]} - #{start_end_event['end_date'][11..15]} ".colorize(color)
            print "#{start_end_event['title']} ".colorize(color)
            puts "(#{start_end_event['id']})".colorize(color)
          end
        end
      else # Si hay elementos que tienen end_date realiza lo siguiente
        n = 1
        all_day_events.each do |all_day_event| # Empieza a imprimir todos los elementos que no tienen end_date
          color = hash_color(all_day_event)
          if n == 1
            print "              "
            print "#{all_day_event['title']} ".colorize(color)
            puts "(#{all_day_event['id']})".colorize(color)
            n = 2
          else
            print "                          "
            print "#{all_day_event['title']} ".colorize(color)
            puts "(#{all_day_event['id']})".colorize(color)
          end
        end
        start_end_events.each do |start_end_event| # Empieza a imprimir todos los elementos que tienen end_date
          color = hash_color(start_end_event)
          print "            "
          print "#{start_end_event['start_date'][11..15]} - #{start_end_event['end_date'][11..15]} ".colorize(color)
          print "#{start_end_event['title']} ".colorize(color)
          puts "(#{start_end_event['id']})".colorize(color)
        end
      end
    end
    tmp_date += 1
    puts ""
  end
  print $menu.colorize(:light_cyan)
end

def update_events(events, new_id)
  tmp_array = events.select { |event| new_id == event["id"] }
  print "date: ".colorize(:light_cyan)
  date = gets.chomp
  date = check_empty(date, "date", "Type a valid date: YYYY-MM-DD")
  print "title: ".colorize(:light_cyan)
  title = gets.chomp
  title = check_empty(title, "title", "Cannot be blank")
  print "calendar: ".colorize(:light_cyan)
  calendar = gets.chomp
  calendar = "default" if calendar.empty?

  print "start_end: ".colorize(:light_cyan)
  start_end = gets.chomp
  start_end = check_start_end(start_end)
  tmp_string_end = "#{date}T#{start_end[6..10]}:00-05:00"
  if start_end.empty?
    start_end = "00:00 23:59"
    tmp_string_end = ""
  end
  print "notes: ".colorize(:light_cyan)
  notes = gets.chomp
  print "guests: ".colorize(:light_cyan)
  guests = gets.chomp.split(", ")
  tmp_hash = { "start_date" => "#{date}T#{start_end[0..4]}:00-05:00", "title" => title,
               "end_date" => tmp_string_end, "notes" => notes, "guests" => guests, "calendar" => calendar }
  print $menu.colorize(:light_cyan)
  events[events.index(tmp_array[0])].merge!(tmp_hash)
end

def create_event(events, id)
  print "date: ".colorize(:light_cyan)
  date = gets.chomp
  date = check_empty(date, "date", "Type a valid date: YYYY-MM-DD")
  print "title: ".colorize(:light_cyan)
  title = gets.chomp
  title = check_empty(title, "title", "Cannot be blank")
  print "calendar: ".colorize(:light_cyan)
  calendar = gets.chomp
  calendar = "default" if calendar.empty?

  print "start_end: ".colorize(:light_cyan)
  start_end = gets.chomp
  start_end = check_start_end(start_end)
  tmp_string_end = "#{date}T#{start_end[6..10]}:00-05:00"
  if start_end.empty?
    start_end = "00:00 23:59"
    tmp_string_end = ""
  end
  print "notes: ".colorize(:light_cyan)
  notes = gets.chomp
  print "guests: ".colorize(:light_cyan)
  guests = gets.chomp.split(", ")
  new_event = { "id" => id, "start_date" => "#{date}T#{start_end[0..4]}:00-05:00", "title" => title,
                "end_date" => tmp_string_end, "notes" => notes, "guests" => guests, "calendar" => calendar }
  events.push(new_event)
  print $menu.colorize(:light_cyan)
end
