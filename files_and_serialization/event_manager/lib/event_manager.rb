require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,'0')[0..4]
end

def is_digit?(char)
  if char.ord >= 48 && char.ord <= 57
    true
  end
end

def clean_phone_numbers(phone_number)
  cleaned_phone_number = ''
  for index in 0...phone_number.length
    cleaned_phone_number += phone_number[index] if is_digit?(phone_number[index])
  end

  if cleaned_phone_number.length == 10
    return cleaned_phone_number
  elsif cleaned_phone_number.length > 10 && cleaned_phone_number[0] == '1'
    return cleaned_phone_number[1..-1]
  else 
    return 'N/A'
  end
end

def clean_date(row)
  new_year = '20' + row[:regdate].split(' ')[0][-2..-1]
  cleaned_date = row[:regdate].split(' ')[0][0..-3] + new_year
end

def tally_registration_hours(registration_hour_tally, hour)
  registration_hour_tally["#{hour.to_s.ljust(4,'0')}"] += 1
end

def get_registration_hours_sorted(registration_hour_tally)
  registration_hour_tally.sort_by {|k, v| v}.reverse.each do |value|
    puts "Time: #{value[0]}   Tally: #{value[1]}"
  end
end

def tally_weekday(registration_weekday_tally,day)
  registration_weekday_tally[day] += 1
end

def get_registration_weekday_sorted(registration_weekday_tally)
  registration_weekday_tally.sort_by {|k, v| v}.reverse.each do |value|
    puts "Weekday: #{value[0]}   Tally: #{value[1]}"
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists?('output')

  filename = "output/thanks_#{id}.html"
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts "EventManager Initialized."

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

registration_hour_tally = Hash.new(0)
registration_weekday_tally = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  phone = clean_phone_numbers(row[:homephone]) 

  date = Date.strptime(clean_date(row), '%m/%d/%Y')
  time = row[:regdate].split(' ')[1]
  date_time = Time.new(date.year.to_i, date.month.to_i, date.day.to_i, hour = time[0..1].to_i, minutes = time[3..4].to_i)
  
  tally_registration_hours(registration_hour_tally, date_time.hour)

  tally_weekday(registration_weekday_tally, date_time.strftime("%A"))
  
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end

get_registration_hours_sorted(registration_hour_tally)

get_registration_weekday_sorted(registration_weekday_tally)
