#encoding: UTF-8
module ModeloQytetet
  class Casilla
    attr_reader:numeroCasilla
    attr_reader:coste
    attr_reader:tipo
    attr_reader:NUM_CASILLAS

    
    def initialize(numeroCasilla, precio, tipo)
        @numeroCasilla = numeroCasilla
        @coste = precio
        @tipo = tipo
    end
    
    def self.creaNoCalle(numeroCasilla, coste, tipo)
      self.new(numeroCasilla, coste, tipo)
    end
    
    def soyEdificable()
      return @tipo == TipoCasilla::CALLE
    end
    
    def getNumeroCasilla()
      return @numeroCasilla
    end
    
    def getTipo()
      return @tipo
    end
    
    def pagarAlquiler()
      return @coste
    end
    
    
    def to_s
            return "Casilla{        numeroCasilla= #{@numeroCasilla}, tipo= #{@tipo}}\n"
    end
    
  end
end
