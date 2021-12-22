require 'test/unit'
require_relative './Effect'

class TestEffect < Test::Unit::TestCase
  TEST_TEXT = 'Ruby is fun!'
  def test_reverse
    reverse_proc = Effect.reverse
    
    assert_equal('ybuR si !nuf', reverse_proc.call(TEST_TEXT))
  end

  def test_loud
    loud_proc = Effect.loud
    
    assert_equal('RUBY!! IS!! FUN!!!', loud_proc.call(TEST_TEXT))
  end

  def test_echo
    echo_proc = Effect.echo

    assert_equal('RRuubbyy iiss ffuunn!!', echo_proc.call(TEST_TEXT))
  end
end
