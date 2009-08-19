Cmdline Parser

I intended to design the command line parser to be embedded into my application. 
However, since more and more project of mine include this as library, i decided to separate it out as gem so that
i can share it with all my project instead. After all, if i update in one place, all my project received the update.
Many thanks to Choice developer (http://choice.rubyforge.org/) chris[at]ozmm[dot]org for providing me the inspiration!

The reason i didn't use choice is that I couldn't figure out how to control when i want it to parse. That's the reason
the method name is parse_list, which trigger the parsing only when i need it with the data i provided, not only from ARGV.

Please sent me comment of your usage of the library! I would love to hear that!

Author : Chris Liaw
Copyright : Chris Liaw
License : GNU LGPL

Usage:

Create option:
	require 'rubygems'
	require 'cmdlineparser'
	
	parser = CmdlineParser.new
	parser.choice :name do |option|
		option.short = "-f"   	# short flag user need to enter
		option.long = "--file" 	#long flag user need to enter
		option.desc = "Specified which file to process" #description for this flag. Printed out in help message
		option.has_value = true # or false as default. Indicate that the parser should store the value followed the flag or else parser ignore it
		option.mandatory = true # or false as default. Indicate the option is a must and if missing, it will throw MissingArgumentException
	end
	
	begin
		parser.parse_list(ARGV) # parameter can be any list, ARGV just for sample. See test/test_cmdline_parser.rb for sample.
	rescue MissingArgumentException => ex  # If any mandatory flag was not given by user, this error will be triggered. 
		STDERR.puts "ERROR: #{ex.message}" # If a flag requires value but value not given, this error will also be triggered.
	end
	
	if parser.name_obj.activated 	# check if user provide the flag. name => name_obj to differentiate user want the object instead the value
		parser.name 				# return the value given by user
	end
	
	parser.params 					# return any free parameter which is not tied to any flag. It could be the parameter for the function call.
	
	parser.show_help				# print out the help message.
	
