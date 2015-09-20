#!/usr/bin/ruby -I./lib/ -I../lib/


require 'test/unit'
load './vcs-wrapper'




#
# Unit test for our parser.
#
class TestConfigParser < Test::Unit::TestCase




  #
  # Create the test suite environment: NOP.
  #
  def setup
  end




  #
  # Destroy the test suite environment: NOP.
  #
  def teardown
  end




  #
  #  Test we can create a new parser object - specifically
  # that it throws exceptions if it is not given a filename
  # that exists.
  #
  def test_init

    #
    #  Constructor
    #
    assert_nothing_raised do
      ConfigFile.instance
    end
  end


  def test_simple_line
    parser = ConfigFile.instance

    input = ['simpsons = lisa, bart, homer, marge',
             'smith  = stan, francine, hailey, steve']
    parser._parse(input)

    # Lookup known-good data
    ret = parser.permissions('simpsons')

    # Ensure it contains what we expect it to
    assert(ret.is_a? Array)
    assert(ret.size == 4)
    assert(ret.include?('bart'))
    assert(ret.include?('lisa'))
    assert(ret.include?('homer'))
    assert(ret.include?('marge'))

    # Lookup known-good data
    ret = parser.permissions('smith')

    # Ensure it contains what we expect it to
    assert(ret.is_a? Array)
    assert(ret.size == 4)
    assert(ret.include?('steve'))
    assert(ret.include?('hailey'))
    assert(ret.include?('francine'))
    assert(ret.include?('stan'))

    # Lookup bogus-data
    ret = parser.permissions('ren_and_stimpy')
    assert(!ret)
  end

end
