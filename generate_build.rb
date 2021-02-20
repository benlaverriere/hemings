#!/usr/bin/env ruby

require 'active_support/inflector'

# ninja's job is making sure we have all of the (up-to-date) outputs we've defined.  From the ninja manual: "When the
# output files are missing or when the inputs change, Ninja will run the rule to regenerate the outputs." So the goal of
# this script is to generate a rule for each plaintext recipe available.

BUILD_FILE = 'build.ninja'
INPUT_FILE_GLOB = './plain/*.md'
FULL_OUTPUT_FILE = './rendered/full.pdf'
CSS_FILE = 'print.css'

GENERATOR_RULE = <<~RULE
rule generate
  command = ruby generate_build.rb
  description = generate
  generator = 1
RULE

COMBINE_PAGES_RULE = <<~RULE
rule render
  command = pandoc -f markdown -t html --css #{CSS_FILE} --variable papersize:letter --file-scope -o $out $in
  description = render $out ← $in
RULE

File.open(BUILD_FILE, "w") { |f|
  f.puts GENERATOR_RULE
  f.puts COMBINE_PAGES_RULE
  f.puts "build #{BUILD_FILE}: generate | generate_build.rb"

  input_files = Dir[INPUT_FILE_GLOB].sort
  output_files = []
  input_files.each { |input_file|
    basename = File.basename(input_file, '.*')
    output_file = "rendered/singles/#{basename}.pdf"
    output_files << output_file
  }

  f.puts "build #{FULL_OUTPUT_FILE}: render #{input_files.join(' ')} | #{CSS_FILE}"

  recipe_count = input_files.size
  puts "Wrote build script for #{recipe_count} #{"recipe".pluralize(recipe_count)} to #{BUILD_FILE}."
}
