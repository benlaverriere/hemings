#!/usr/bin/env ruby

require 'active_support/inflector'

# ninja's job is making sure we have all of the (up-to-date) outputs we've defined.  From the ninja manual: "When the
# output files are missing or when the inputs change, Ninja will run the rule to regenerate the outputs." So the goal of
# this script is to generate a rule for each plaintext recipe available.

BUILD_FILE = 'build.ninja'
INPUT_FILE_GLOB = './plain/*.md'
RENDER_PAGE_RULE = <<~RULE
rule recipe2pdf
  command = pandoc -f markdown -t html --variable papersize:letter -s -o $out $in
  description = recipe2pdf $in $out

RULE

File.open(BUILD_FILE, "w") { |f|
  input_files = Dir[INPUT_FILE_GLOB]
  f.write RENDER_PAGE_RULE
  input_files.each { |file|
    basename = File.basename(file, '.*')
    f.write "build rendered/singles/#{basename}.pdf: recipe2pdf #{file}\n"
  }
  f.write "\n"
  rule_count = input_files.size
  puts "Wrote #{rule_count} #{"rule".pluralize(rule_count)} to #{BUILD_FILE}."
}
