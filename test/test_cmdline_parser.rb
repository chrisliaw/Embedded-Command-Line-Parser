
require '../lib/cmdline_parser'
require 'test/unit'

class TestCmdlineParser < Test::Unit::TestCase
  def test_output
    list = ["-f","/media/share/testing.txt","--revision","10", "--mandatory","extra_parameter"]
    parser = CmdlineParser.new
    parser.choice :file do |opt|
      opt.short = "-f"
      opt.long = "--file"
      opt.has_value = true
      opt.desc = "File parameter"
    end
    
    parser.choice :revision do |opt|
      opt.short = "-r"
      opt.long = "--revision"
      opt.desc = "Particular revision"
      opt.has_value = true
    end
    
    parser.choice :mand do |opt|
      opt.short = "-m"
      opt.long = "--mandatory"
      opt.desc = "Mandatory field!"
      opt.mandatory = true
    end
    
    parser.choice :ignore do |opt|
      opt.short = "-i"
      opt.long = "--ignore"
      opt.desc = "meant to be ignore!"
    end
    
    parser.parse_array(list)
    
    assert_equal(parser.file,list[1])
    assert_equal(parser.file_obj.activated,true)
    
    assert_equal(parser.revision,list[3])
    assert_equal(parser.revision_obj.activated,true)
    
    assert_equal(parser.mand_obj.activated,true)
    
    assert_equal(parser.ignore_obj.activated,false)
    
    assert_equal(parser.params,[list[5]])
  end
end