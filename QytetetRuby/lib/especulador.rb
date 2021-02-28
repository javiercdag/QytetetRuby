# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
#require_relative "jugador"

module ModeloQytetet

class Jugador 
end  
  class Especulador < Jugador
    
    def self.copia(unJugador, fianza)
      copia = super(unJugador)
      copia.setFianza(fianza)
      return copia
    end
    
    def convertirme(fianza)
      @fianza = fianza
      return self
    end
    
    def pagarImpuesto()
      modificarSaldo((-@casillaActual.getCoste()/2).to_i)
    end
    
    def deboIrACarcel()
      a_devolver = ((super == true) && (pagarFianza() == false));
        
      return a_devolver
    end
    
    private 
    def pagarFianza()
      a_devolver = getSaldo() > @fianza;
        
      if (a_devolver)
        modificarSaldo(-@fianza);
      end
      
      return a_devolver;
    end
    
    protected 
    def puedoEdificarCasa(titulo)
        numCasas = titulo.getNumCasas()
        costeEdificar = titulo.getPrecioEdificar()
        edificable = false
        
        if (numCasas<8 && tengoSaldo(costeEdificar))
                edificable = true
        end
        
        return edificable
    end
    
    def puedoEdificarHotel(titulo)
        numHoteles = titulo.getNumHoteles()
        costeEdificar = titulo.getPrecioEdificar()
        edificable = false
        
        if (numHoteles<8 && tengoSaldo(costeEdificar) && titulo.getNumCasas() >= 4)
                edificable = true
        end
        
        return edificable
    end
    
    public
    def setFianza(nueva)
      @fianza = nueva
    end
      
    public
    def to_s()
      "#{super} El jugador anterior es un especulador. Su fianza es: #{@fianza}\n\n"
    end
    
  end
end
