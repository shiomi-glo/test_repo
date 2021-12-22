class Synth
  def initialize(text)
    @effects = []
    @text = text
  end

  def add_effect(effect)
    @effects << effect.to_proc # effectはproc
  end

  def play
    @effects.each do |effect|
      @text = effect.call(@text)
    end

    @text
  end
end