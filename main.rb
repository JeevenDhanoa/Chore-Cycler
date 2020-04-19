
require_relative 'resident'
require_relative 'cycle'
require 'date'
require 'time'

# A method to write each new cycle to the setup file in case the server reboots and that data is lost
def write_info_file
  file_info = File.read("setup-info.txt").split("\n")
  file_info.delete("")

  number_of_people = file_info[0].to_i
  lines_to_keep = file_info.drop(number_of_people * 3 + 1)

  string_to_write = "#{number_of_people}"
  @residents.each { |resident| string_to_write += "\n#{resident.name}\n#{resident.email}\n#{resident.chore}" }
  lines_to_keep.each { |line| string_to_write += "\n#{line}"}

  File.write("setup-info.txt", string_to_write)
end

# A method to perform all tasks associated with cycling chores
def cycle_all(formatted_date)

  # Create array of current chores for use later when rotating chores
  chore_cycles_previous_chores = []
  @chore_cycles.each do |cycle|
    previous_chores = []
    cycle.people.each { |person| 
    previous_chores << person.chore }
    chore_cycles_previous_chores << previous_chores
  end

  # Set current chores to nil, then cycle, send emails, and update file info
  @residents.each { |resident| resident.chore = nil}
  @chore_cycles.each_with_index { |cycle, index| cycle.rotate(chore_cycles_previous_chores[index])}
  @residents.each { |resident| resident.send_email(formatted_date)}
  write_info_file
end

# A method to read, parse, and store information in the setup file
def setup
  # First read all data from the setup-info.txt file
  setup_info = File.read("setup-info.txt").split("\n")
  setup_info.delete("")
  parse_index = 1

  # Create new resident instances for each person and put them all in an array
  @residents = []
  setup_info[0].to_i.times do
    @residents << Resident.new(setup_info[parse_index], setup_info[parse_index + 1], setup_info[parse_index + 2])
    parse_index += 3
  end

  # Create chore cycles
  @chore_cycles = []
  setup_info[parse_index].to_i.times do
    parse_index += 1
    cycle_name = setup_info[parse_index]
    parse_index += 1

    people = []
    setup_info[parse_index].to_i.times do
      parse_index += 1
      person_name = setup_info[parse_index]
      person = @residents.find { |resident| resident.name == person_name}
      people << person
    end
    parse_index += 1

    chores = []
    setup_info[parse_index].to_i.times do
      parse_index += 1
      chores << setup_info[parse_index]
    end

    @chore_cycles << Cycle.new(cycle_name, chores, people)
  end
end

# Call the method to read info from the setup file
setup

# The main program loop
while true

  # Check if it is monday and if the current time is between 00:00 and 00:29
  current_time = Time.now
  if current_time.wday == 1 and current_time.hour == 0 and current_time.min.between?(0, 29)

    # Generate formatted date string
    formatted_date = "#{Date::MONTHNAMES[current_time.month]} #{current_time.day}"
    cycle_all(formatted_date)
  end

  sleep(1800)
end

