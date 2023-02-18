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
  # puts "Event ID: #{tmp_array[0]['id']}"
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
  tmp_string_end = "" if start_end.length == 5

  print "notes: "
  notes = gets.chomp
  print "guests: "
  guests = gets.chomp.split(", ")
  tmp_hash = {
    "start_date" => "#{date}T#{start_end[0..4]}:00-05:00",
    "title" => title,
    "end_date" => tmp_string_end,
    "notes" => notes,
    "guests" => guests,
    "calendar" => calendar
  }
  puts "-" * 78
  puts "list | create | show | update | delete | next | prev | exit"
  events[events.index(tmp_array[0])].merge!(tmp_hash)
end

def show(events)
  print "Event ID: "
  id = gets.chomp.to_i
  evento_a_mostrar = events.find { |evento| evento["id"] == id }
  dat = evento_a_mostrar["start_date"].split("T")
  puts "date: #{dat[0]}"
  puts "title: #{evento_a_mostrar['title']}"
  puts "calendar: #{evento_a_mostrar['calendar']}"
  hora_inicio = evento_a_mostrar["start_date"][11..15]
  hora_termino = evento_a_mostrar["end_date"][11..15]
  if !hora_termino.nil?
    puts "Start_end: #{hora_inicio}-#{hora_termino}"
  else
    puts "Start_end: Es un evento para todo el dia"
  end
  puts "Notes: #{evento_a_mostrar['notes']}"
  cad = evento_a_mostrar["guests"].join(", ")
  puts "guests: #{cad}"
  puts "-" * 78
  puts "list | create | show | update | delete | next | prev | exit"
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
  print "Event ID: "
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
  puts "#{'-' * 29}#{msg}#{'-' * 30}"
  puts ""
  for i in 1..7 do
    print "#{tmp_date.strftime('%a')} #{tmp_date.strftime('%b')} #{tmp_date.strftime('%d')}  " # Calendario
    tmp_events = events.select { |event| tmp_date.day == Date.parse(event["start_date"]).day } # Almacena en un array los eventos cuyo dia sea igual al que se esta imprimiendo
    tmp_empty_ends = []
    tmp_full_starts = []
    if tmp_events.length != 0
      tmp_events.each do |tmp_event|
        if tmp_event["end_date"] == ""
          tmp_empty_ends.push(tmp_event)
        else
          tmp_full_starts.push(tmp_event)
        end
      end
      sort_array_hashes(tmp_full_starts, "start_date")
      if tmp_empty_ends.length != 0
        n = 1
        tmp_empty_ends.each do |tmp_empty_end|
          if n == 1
            print "              "
            print "#{tmp_empty_end['title']} "
            puts "(#{tmp_empty_end['id']})"
            n = 2
          else
            print "                          "
            print "#{tmp_empty_end['title']} "
            puts "(#{tmp_empty_end['id']})"
          end

        end
        tmp_full_starts.each do |tmp_full_start|
          print "            #{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} "
          print "#{tmp_full_start['title']} "
          puts "(#{tmp_full_start['id']})"
        end
      else
        m = 1
        tmp_full_starts.each do |tmp_full_start|
          if m == 1
            print "#{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} "
            print "#{tmp_full_start['title']} "
            puts "(#{tmp_full_start['id']})"
            m = 2
          else
            print "            #{tmp_full_start['start_date'][11..15]} - #{tmp_full_start['end_date'][11..15]} "
            print "#{tmp_full_start['title']} "
            puts "(#{tmp_full_start['id']})"
          end
        end
      end
    else
      puts "              No events"
    end
    tmp_date += 1
    puts ""
  end
  puts "-" * 78
  puts "list | create | show | update | delete | next | prev | exit"
end

def create_event(events, id)
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
  tmp_string_end = "" if start_end.length == 5
  print "notes: "
  notes = gets.chomp
  print "guests: "
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
  puts "-" * 78
  puts "list | create | show | update | delete | next | prev | exit"
end