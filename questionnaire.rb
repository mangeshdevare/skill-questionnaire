require "pstore" # https://github.com/ruby/pstore
require "securerandom"

STORE_NAME = "tendable.pstore.mangesh"
STORE = PStore.new(STORE_NAME)
# for each user survey will be saved under unique key
# to make it more reliable we can check if key already exists
SURVEY_KEY = SecureRandom.hex(6)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# Prompt the user to answer each question and store the answers in the PStore
def do_prompt
  answers = {}
  QUESTIONS.each do |question_key, question_text|
    print "#{question_text} (Y/N): "
    answer = gets.chomp.upcase # answer becomes case insensitive
    until ["Y", "N"].include?(answer)
      puts "Please enter 'Y' or 'YES' for Yes and 'N' or 'NO' for No."
      print "#{question_text} -> "
      answer = gets.chomp.upcase
    end
    answers[question_key] = answer
  end
  # stores the answers in pstore
  STORE.transaction do
    STORE["answers_#{SURVEY_KEY}"] = answers
  end
end

# Calculates rating based on the number of yes answers
def calculate_rating(answers)
  num_yes = answers.count { |_, answer| answer == "Y" || answer == "YES" }
  (100 * num_yes / QUESTIONS.size.to_f).round(2)
end

def do_report
  STORE.transaction(true) do
    answers = STORE["answers_#{SURVEY_KEY}"]
    rating = calculate_rating(answers)
    puts "Survey Report:"
    puts "Your rating for this run: #{rating}%"
    average_rating = calculate_average_rating
    puts "Average rating for all runs: #{average_rating.round(2)}%"
  end
end

# Calculate the average rating for all runs
def calculate_average_rating
  total_rating = 0
  total_runs = 0
  STORE.roots.each do |key|
    answers = STORE[key]
    total_rating += calculate_rating(answers)
    total_runs += 1
  end
  total_rating / total_runs.to_f
end

do_prompt
do_report
