# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Calle < Casilla
    attr_accessor:titulo
    
    def initialize(numeroCasilla, precio, tipo, titulo)
      super(numeroCasilla, precio, tipo)
      @titulo = titulo
    end
    
    def self.creaCalle(numeroCasilla, coste, titulo)
      self.new(numeroCasilla, coste, TipoCasilla::CALLE, titulo)
    end
    
    def asignarPropietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    
    def getTitulo()
      return @titulo
    end
    
    def pagarAlquiler()
      costeAlquiler = @titulo.pagarAlquiler()
      return costeAlquiler
    end 
    
    def propietarioEncarcelado()
      return @titulo.propietarioEncarcelado()
    end 
    
    def tengoPropietario()
       return @titulo.tengoPropietario()
    end
    
    def to_s
      return "Casilla{        numeroCasilla= #{@numeroCasilla}, coste= #{@coste} , tipo= #{@tipo} ,
                  titulo= #{@titulo.to_s}}\n"
    end
    
  end
end
