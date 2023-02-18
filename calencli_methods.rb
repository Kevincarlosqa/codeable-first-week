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

  return false if new_input.length != 11 # && new_input.length != 5

  c1 = new_input[0..1].to_i
  c2 = new_input[3..4].to_i
  c3 = new_input[6..7].to_i
  c4 = new_input[9..10].to_i
  return false if c1.class != Integer || c2.class != Integer || c3.class != Integer || c4.class != Integer

  a = new_input[0..1].to_i.between?(0, 24)
  b = new_input[3..4].to_i.between?(0, 59)
  x = new_input[6..7].to_i.between?(0, 24)
  y = new_input[9..10].to_i.between?(0, 59)
  a && b && x && y
end

# Valida si la hora de final es mayor que inicio
def check_correct_hours(new_input)
  return true if new_input.empty?

  return true if new_input.length == 5

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
  print "start_end: ".colorize(:light_cyan)
  start_end = gets.chomp
  start_end = check_start_end(start_end)
  tmp_string_end = "#{date}T#{start_end[6..10]}:00-05:00"
  if start_end.empty?
    start_end = "00:00 23:59"
    tmp_string_end = ""
  end
  tmp_string_end = "" if start_end.length == 5

  print "notes: ".colorize(:light_cyan)
  notes = gets.chomp
  print "guests: ".colorize(:light_cyan)
  guests = gets.chomp.split(", ")
  tmp_hash = {
    "start_date" => "#{date}T#{start_end[0..4]}:00-05:00",
    "title" => title,
    "end_date" => tmp_string_end,
    "notes" => notes,
    "guests" => guests,
    "calendar" => calendar
  }
  print $menu.colorize(:light_cyan)
  events[events.index(tmp_array[0])].merge!(tmp_hash)
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
  dat = evento_a_mostrar["start_date"].split("T")
  print "date: ".colorize(:light_cyan)
  puts dat[0].to_s
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
    puts "#{hora_inicio}-#{hora_termino}"
  end
  print "Notes: ".colorize(:light_cyan)
  puts evento_a_mostrar["notes"].to_s
  cad = evento_a_mostrar["guests"].join(", ")
  print "guests: ".colorize(:light_cyan)
  puts cad.to_s
  print $menu.colorize(:light_cyan)
end

# def nuevo_metodo(tipo_color)
#   action = tipo_color
#   case action
#   when "english"
#     return "magenta".to_sym
#   when "web-dev"
#     return "blue".to_sym
#   when "soft-skills"
#     return "green".to_sym
#   when "default"
#     return "default".to_sym
#   else
#     return "light_black".to_sym
#   end
# end

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

## Leer un string como date
# date.parse('2001-02-03')

# # Formato usado
# date.strftime('%FT%T%:z')

# # Numero Semana en String
# date.strftime('%-V')

# DateTime.now

# # Imprimir nombre dia reducido
# date.strftime('%a')

# # Imprimir nombre mes reducido
# date.strftime('%b')

# # Imprimir numero dia del mes con 0 delante
# date.strftime('%d')

# # Obtener numero dia del mes en entero
# date.day

# # Numero dia de la semana
# date.strftime('%u')

# # Convertir a date un elemento de events
# Date.parse(events[0]["start_date"])

# Date.parse(events[0]["start_date"]).day
# tmp_date.day

# Método que ordena un array de hashes por un value
def sort_array_hashes(array_of_hashes, sort_by)
  array_of_hashes.sort_by! { |hsh| hsh[sort_by] }
end

def delete_event(events)
  print "Event ID: ".colorize(:light_cyan)
  id = gets.chomp.to_i
  index_delete = events.find_index { |event| event["id"] == id }
  if index_delete.nil?
    puts "Event not found"
  else
    events.delete_at(index_delete)
    puts "Event deleted"
  end
end

def list(events, date = DateTime.now, msg = "")
  tmp_date = date - (date.strftime("%u").to_i - 1) # Lunes de esta fecha
  puts "#{'-' * 29}#{msg}#{'-' * 30}".colorize(:light_cyan)
  puts ""
  7.times do
    print "#{tmp_date.strftime('%a')} #{tmp_date.strftime('%b')} #{tmp_date.strftime('%d')}  " # Calendario
    # Almacena en un array los eventos cuyo dia sea igual al que se esta imprimiendo
    tmp_events = events.select { |event| tmp_date === Date.parse(event["start_date"]) }
    tmp_empty_ends = []
    tmp_full_starts = []
    if tmp_events.empty? # Si encontró eventos realiza lo siguiente
      puts "              No events"
    else
      tmp_events.each do |tmp_event| # Busca y agrega a 2 array los eventos que no tienen end_date y que tienen end date
        if tmp_event["end_date"] == ""
          tmp_empty_ends.push(tmp_event)
        else
          tmp_full_starts.push(tmp_event)
        end
      end
      sort_array_hashes(tmp_full_starts, "start_date") # Ordena el array de hashes que tienen end_date
      if tmp_empty_ends.empty? # Si hay elementos que tienen end_date realiza lo siguiente
        m = 1
        tmp_full_starts.each do |tmp_full_start| # Empieza a imprimir todos los elementos que tienen end_date
          color = hash_color(tmp_full_start)
          if m == 1
            print "#{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} ".colorize(color)
            print "#{tmp_full_start['title']} ".colorize(color)
            puts "(#{tmp_full_start['id']})".colorize(color)
            m = 2
          else
            print "            #{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} ".colorize(color)
            print "#{tmp_full_start['title']} ".colorize(color)
            puts "(#{tmp_full_start['id']})".colorize(color)
          end
        end
      else # Si no hay elementos que tienen end_date realiza lo siguiente
        n = 1
        tmp_empty_ends.each do |tmp_empty_end| # Empieza a imprimir todos los elementos que no tienen end_date
          color = hash_color(tmp_empty_end)
          if n == 1
            print "              "
            print "#{tmp_empty_end['title']} ".colorize(color)
            puts "(#{tmp_empty_end['id']})".colorize(color)
            n = 2
          else
            print "                          "
            print "#{tmp_empty_end['title']} ".colorize(color)
            puts "(#{tmp_empty_end['id']})".colorize(color)
          end
        end
        tmp_full_starts.each do |tmp_full_start| # Empieza a imprimir todos los elementos que tienen end_date
          color = hash_color(tmp_full_start)
          print "            "
          print "#{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} ".colorize(color)
          print "#{tmp_full_start['title']} ".colorize(color)
          puts "(#{tmp_full_start['id']})".colorize(color)
        end
      end
    end
    tmp_date += 1
    puts ""
  end
  print $menu.colorize(:light_cyan)
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
  tmp_string_end = "" if start_end.length == 5
  print "notes: ".colorize(:light_cyan)
  notes = gets.chomp
  print "guests: ".colorize(:light_cyan)
  guests = gets.chomp.split(", ")
  new_event = {
    "id" => id,
    "start_date" => "#{date}T#{start_end[0..4]}:00-05:00",
    "title" => title,
    "end_date" => tmp_string_end,
    "notes" => notes,
    "guests" => guests,
    "calendar" => calendar
  }
  events.push(new_event)
  print $menu.colorize(:light_cyan)
end
