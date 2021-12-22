module Effect
  class << self
    def reverse
      -> words { words.split.map(&:reverse).join(' ') }
    end

    def loud
      -> words { words.split.map { |w| w.upcase + '!!' }.join(' ') }
    end

    def echo
      -> words { words.split('').map{|char| char == ' ' ? char : char * 2}.join }
    end
  end
end