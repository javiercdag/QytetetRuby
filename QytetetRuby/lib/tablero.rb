#encoding: UTF-8
require_relative "casilla"
require_relative "calle"
require_relative "tipo_casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
module ModeloQytetet
  class Tablero
    attr_reader:casillas
    attr_reader:carcel
    
    
    def esCasillaCarcel(numeroCasilla)
        return (@casillas[numeroCasilla].getTipo() == TipoCasilla::CARCEL)
    end
    
    def getCarcel()
      return @carcel
    end
    
    def getCasillas()
      return @casillas
    end
    
    def inicializar
      @casillas = Array.new
      @casillas << Casilla.creaNoCalle(0, 0, TipoCasilla::SALIDA)
      @casillas << Calle.creaCalle(1, 500, TituloPropiedad.new("Calle Santiago", 500, 50, -20, 150, 250))
      @casillas << Casilla.creaNoCalle(2, 300, TipoCasilla::IMPUESTO)
      @casillas << Calle.creaCalle(3, 500, TituloPropiedad.new("Plaza de Toros", 500, 50, -20, 150, 250))
      @casillas << Calle.creaCalle(4, 500, TituloPropiedad.new("Pedro Antonio", 500, 50, -20, 150, 250))
      @casillas << Calle.creaCalle(5, 600, TituloPropiedad.new("Camino de Ronda", 600, 50, -20, 150, 250))
      @casillas << Casilla.creaNoCalle(6, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.creaCalle(7, 650, TituloPropiedad.new("Calle Sagrada Familia", 650, 65, -20, 350, 400))
      @casillas << Calle.creaCalle(8, 650, TituloPropiedad.new("Calle San Matías", 650, 65, -20, 350, 400))
      @casillas << Casilla.creaNoCalle(9, 0, TipoCasilla::CARCEL)
      @casillas << Calle.creaCalle(10, 700, TituloPropiedad.new("San Antón", 700, 65, -20, 350, 400))
      @casillas << Casilla.creaNoCalle(11, 0, TipoCasilla::SORPRESA)
      @casillas << Casilla.creaNoCalle(12, 0, TipoCasilla::PARKING)
      @casillas << Calle.creaCalle(13, 800, TituloPropiedad.new("Paseo del Salón", 800, 80, -20, 700, 550))
      @casillas << Calle.creaCalle(14, 800, TituloPropiedad.new("Carrera de la Virgen", 800, 80, -20, 700, 550))
      @casillas << Casilla.creaNoCalle(15, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.creaCalle(16, 850, TituloPropiedad.new("Gran Vía", 850, 80, -20, 700, 550))
      @casillas << Casilla.creaNoCalle(17, 0, TipoCasilla::JUEZ)
      @casillas << Calle.creaCalle(18, 900, TituloPropiedad.new("Recogidas", 900, 100, -20, 925, 750))
      @casillas << Calle.creaCalle(19, 1000, TituloPropiedad.new("Reyes Católicos", 1000, 100, -20, 925, 750))
      @carcel = @casillas[9]
    end
    
    def obtenerCasillaFinal(casilla, desplazamiento)
      return @casillas[(casilla+desplazamiento) % @NUM_CASILLAS]
    end 
    
    def obtenerCasillaNumero(numeroCasilla)
      return @casillas[numeroCasilla]
    end 
    
    def to_s
        casilla = ""
        casilla = casilla + "Tablero{ casillas=\n"
        
        for c in @casillas
          casilla += c.to_s + "\n"
        end
        
        casilla += @carcel.to_s + "\n"
        
        return casilla+"}"
    end
    
    private_class_method
    def initialize
      inicializar()
      @NUM_CASILLAS = @casillas.size()
    end
    
  end
end
