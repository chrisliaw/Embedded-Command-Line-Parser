
if __FILE__ == $0
  require '../lib/cmdline_parser'
  
  parser = CmdlineParser.new
  parser.choice :first do |opt|
    opt.short = "-f"
    opt.long = "--first"
    opt.has_value = true
    opt.mandatory = true
    opt.desc = "First param"
  end
  
  parser.choice :second do |opt|
    opt.short = "-s"
    opt.long = "--second"
    opt.desc = "Second param"
  end

  parser.choice :third do |opt|
    opt.short = "-t"
    opt.long = "--third"
    opt.desc = "Third param"
    opt.has_value = true
  end

  begin
    parser.parse_array(ARGV)
  rescue MissingArgumentException => ex
    STDERR.puts "Error : #{ex.message}"
    parser.show_help
    exit(1)
  end
  
  parser.choices.each do |c|
    if c.activated
      STDOUT.print "Flag '#{c.name}' activated by user"
    else
      STDOUT.print "Flag '#{c.name}' not activated by user"
    end
    
    if c.value
      STDOUT.puts " with value '#{c.value}'"
    else
      STDOUT.puts ""
    end
  end
  
  STDOUT.puts "Extra parameter for command : #{parser.params.join(" , ")}"
  
end