

class CmdlineParser
  attr_accessor :choices, :params
  
  VERSION = "0.1.0"
  
  def initialize(opt = {})
    @choices = []
    @short_map = {}
    @long_map = {}
    @params = []
    @mandatory_choice = {}
    @search = {}
    @error_as_message = opt[:error_as_message]
    @error_as_message ||= false 
  end
  
  def choice(name)
    opt = Opt.new
    opt.name = name
    yield opt
    @choices << opt
    @search[opt.name] = opt
  end
  
  def parse_array(argv)
    prepare_index
    ignore_value = []
    0.upto(argv.length-1) do |i|
      token = argv[i].strip
      if @short_map.keys.include? token
        opt = @short_map[token]
        opt.activated = true
        if opt.has_value == true
          tmpVal = argv[i+1]
          if is_command(tmpVal)
            if @error_as_message
              STDERR.puts "Argument needed for flag #{token}"              
            else
              raise MissingArgumentException, "Argument needed for flag #{token}"
            end
          else
            if tmpVal != nil
              opt.value = tmpVal
              ignore_value << tmpVal
            else
              if @error_as_message
                STDERR.puts "Argument needed for flag #{token}"              
              else
                raise MissingArgumentException, "Argument needed for flag #{token}"
              end
            end
          end
        end
        
        if @mandatory_choice.keys.include? opt.name
          @mandatory_choice.delete(opt.name)
        end
        
      elsif @long_map.keys.include? token
        opt = @long_map[token]
        opt.activated = true
        if opt.has_value == true
          tmpVal = argv[i+1]
          if is_command(tmpVal)
            if @error_as_message
              STDERR.puts "Argument needed for flag #{token}"              
            else
              raise MissingArgumentException, "Argument needed for flag #{token}"
            end
          else
            if tmpVal != nil
              opt.value = tmpVal
              ignore_value << tmpVal
            else
              if @error_as_message
                STDERR.puts "Argument needed for flag #{token}"              
              else
                raise MissingArgumentException, "Argument needed for flag #{token}"
              end
            end
          end
        end
        
        if @mandatory_choice.keys.include? opt.name
          @mandatory_choice.delete(opt.name)
        end
        
      else
        if not ignore_value.include? token
          @params << token
        end
      end
    end
    
    if @mandatory_choice.length > 0
      msg = []
      @mandatory_choice.values.each do |ch|
        msg << "#{ch.short} or #{ch.long}"
      end
      
      if @error_as_message
        STDERR.puts "Error : Flag #{msg.join(",")} is required for this command"              
      else
        raise MissingArgumentException,"Flag #{msg.join(",")} is required for this command"
      end
      
    end
    
  end
  
  def show_help
    STDOUT.puts ""
    STDOUT.puts "Ruby Cmdline Parser version #{CmdlineParser::VERSION}"
    STDOUT.puts ""
    STDOUT.puts "   Available commands:"
#    STDOUT.puts ""
    @choices.each do |c|
      STDOUT.print "%5s or %-12s" % [c.short, c.long]
      if c.has_value
        STDOUT.print "<param> "
      else
        STDOUT.print "        "
      end
      
      if c.mandatory
        STDOUT.print "[Required] "
      else
        STDOUT.print "           "
      end
      STDOUT.puts c.desc
    end
    STDOUT.puts ""
    
  end
  
  private
  def is_command(token)
    if token != nil
      token[0].chr == "-" || token[0..1] == "--"
    else
      false
    end
  end
  
  def prepare_index
    @choices.each do |ch|
      @short_map[ch.short] = ch
      @long_map[ch.long] = ch
      if ch.mandatory == true
        @mandatory_choice[ch.name] = ch
      end
    end
  end
  
  alias :old_method_missing :method_missing
  def method_missing(arg)
    if @search[arg] != nil
      return @search[arg].to_s
    end
    
    if arg.to_s()[arg.to_s.length-4..-1] == "_obj"
      key = arg.to_s()[0...-4]
      if @search[key.to_sym] != nil
        return @search[key.to_sym]
      end
    end
    
    old_method_missing(arg)
    #puts "method missing! #{arg}"
  end
end

class Opt
  attr_accessor :name, :short, :long, :desc, :mandatory, :default, :value, :has_value, :activated
  def initialize
    @mandatory = false
    @has_value = false
    @activated = false
  end

  def to_s
    value
  end
end

class MissingArgumentException < Exception
  
end
