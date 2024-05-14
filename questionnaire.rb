require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# TODO: FULLY IMPLEMENT
def do_prompt
  # Ask each question and get an answer from the user's input.
  QUESTIONS.each_key do |question_key|
    print QUESTIONS[question_key]
    ans = gets.chomp
  end
end

def do_report
  # TODO: IMPLEMENT
end

do_prompt
do_report
