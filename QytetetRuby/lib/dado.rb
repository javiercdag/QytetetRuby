#encoding: UTF-8
require "singleton"

module ModeloQytetet
  class Dado
    include Singleton
    attr_reader:valor
    
    
    def initialize
      @valor = nil
    end
    
    @@instance = new
    
    def self.getInstance
        @@instance
    end
    
    def tirar()
        numero = rand(6)+1;
        @valor = numero;
        
        return @valor;
    end 

    def to_s()
        return "Dado{ valor=  #{@valor}  }"
    end
    
  end
end
