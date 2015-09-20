#!/usr/bin/ruby


require 'test/unit'
load './vcs-wrapper'




#
# Simple unit-test for our access-control
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
      VCSWrapper.new( [ 'user', 'steve' ], 'bar' )
    end
  end

  #
  # Test simple ACL
  #
  def test_simple_lookup

    # Create a helper
    args = [ "repo", "foo" ]
    cmd  = "git-upload-pack 'foo'"
    vcs  = VCSWrapper.new( args, cmd)

    # The helper should be able to access 'foo', but nothing else.
    assert(vcs.access?('/foo'))
    assert(vcs.access?('/home/repos/foo/'))
    assert(vcs.access?('/home/git/foo/'))

    assert(!vcs.access?('bar'))
    assert(!vcs.access?('bar.git'))
    assert(!vcs.access?('/bar'))
    assert(!vcs.access?('bar.git'))
  end

  #
  # Test that space-seperated repos work
  #
  def test_named_repos

    # Create a helper
    args = [ "repo", "foo", "bar" ]
    cmd  = "git-upload-pack 'foo'"
    vcs  = VCSWrapper.new( args, cmd)

    # The helper should be able to access 'foo', and 'bar'
    assert(vcs.access?('/foo'))
    assert(vcs.access?('/home/repos/foo/'))
    assert(vcs.access?('/home/git/foo/'))

    assert(vcs.access?('bar'))
    assert(vcs.access?('bar/'))
    assert(vcs.access?('/bar'))
  end

  #
  #  Test via a user and configuration file
  #
  def test_config_file
    parser = ConfigFile.instance
    parser._parse(['user = foo, bar','boss  = all'])

    # Now do a login and access-check.
    vcs = VCSWrapper.new(['user', 'user'], 'git-upload-pack "foo"')

    # The user 'user' should be able to access 'foo', and 'bar'
    assert(vcs.access?('/foo'))
    assert(vcs.access?('/bar'))
    assert(!vcs.access?('/baz'))
    assert(!vcs.access?('/private'))

    # The user 'boss' should be able to access everything.
    boss = VCSWrapper.new(['user', 'boss'], 'git-upload-pack "foo"')
    assert(boss.access?('/foo'))
    assert(boss.access?('/bar'))
    assert(boss.access?('/baz'))
    assert(boss.access?('/private'))

  end
end
