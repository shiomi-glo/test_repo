require 'test/unit'
require_relative './Effect'
require_relative './Synth'

class TestSynth < Test::Unit::TestCase
  TEST_TEXT = 'Ruby is fun!'

  def setup
    @synth = Synth.new(TEST_TEXT)
  end

  def test_reverse
    @synth.add_effect Effect.reverse
    assert_equal('ybuR si !nuf', @synth.play)
  end

  def test_all
    @synth.add_effect Effect.reverse
    @synth.add_effect Effect.echo
    @synth.add_effect Effect.loud
    assert_equal('!!YYBBUURR !!SSII !!!NNUUFF', @synth.play)
  end
end
