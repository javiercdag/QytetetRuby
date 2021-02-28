#encoding: UTF-8
require_relative "casilla"
require_relative "especulador"

module ModeloQytetet
  class Jugador
    
    private
    def initialize (nombre, saldo, cartaLibertad, casillaActual, encarcelado, propiedades)
      @nombre = nombre
      @saldo = saldo
      @cartaLibertad = cartaLibertad
      @casillaActual = casillaActual
      @encarcelado = encarcelado
      @propiedades = propiedades
    end
    
    public
    def self.nuevo(nombre)
      new(nombre, 7500, nil, 0, false, Array.new())
    end
    
    def self.copia(otroJugador)
      new(otroJugador.getNombre(), otroJugador.getSaldo(), otroJugador.getCartaLibertad(),
          otroJugador.getCasillaActual(), otroJugador.getEncarcelado(), otroJugador.getPropiedades())
    end
     
    def cancelarHipoteca(titulo)
        coste = titulo.calcularCosteCancelar()
        cancelada = false
        
        if @saldo > coste
            modificarSaldo(-coste)
            titulo.cancelarHipoteca()
            cancelada = true
        end
        
        return cancelada
    end
    
    
    def comprarTituloPropiedad()
        costeCompra = @casillaActual.coste
        
        if costeCompra < @saldo
            titulo = @casillaActual.asignarPropietario(self)
            @propiedades << titulo
            modificarSaldo(-titulo.precioCompra)
        end
        
        return (costeCompra < @saldo);
    end

    #protected
    def convertirme(fianza)
        return Especulador.copia(self, fianza)
    end

    public
    def cuantasCasasHotelesTengo()
      casasHoteles = 0;
        
      for t in @propiedades
          casasHoteles += t.getNumHoteles() + t.getNumCasas();
      end
      
      return casasHoteles;
    end
    
    def deboIrACarcel()
      return !tengoCartaLibertad()
    end
    
    def deboPagarAlquiler()
        deboPagar = false
        esDeMiPropiedad = esDeMiPropiedad(@casillaActual.titulo)
        tienePropietario = false
        encarcelado = true
        estaHipotecada = true
        
        if !esDeMiPropiedad
            tienePropietario = @casillaActual.tengoPropietario()
            
            if tienePropietario
                encarcelado = @casillaActual.propietarioEncarcelado()
                estaHipotecada = @casillaActual.getTitulo().getHipotecada()
            end
        end
        
        deboPagar = !esDeMiPropiedad & tienePropietario & !encarcelado &!estaHipotecada
        
        return deboPagar;
    end
    
    def devolverCartaLibertad()
      cartaIntercambio = @cartaLibertad;
      @cartaLibertad = nil;
      return cartaIntercambio;  
    end
    
    def edificarCasa(titulo)
        edificada = false
        
        if puedoEdificarCasa(titulo)
            costeEdificarCasa = titulo.getPrecioEdificar()
            titulo.edificarCasa()
            modificarSaldo(-costeEdificarCasa)
            edificada = true
        end
        
        return edificada
    end
    
    def edificarHotel(titulo)
        edificada = false
        
        if puedoEdificarHotel(titulo)
            costeEdificarHotel = titulo.getPrecioEdificar()
            titulo.edificarHotel()
            modificarSaldo(-costeEdificarHotel)
            edificada = true
        end
        
        return edificada
    end
    
    private
    def eliminarDeMisPropiedades(titulo)
        @propiedades.delete(titulo)
        titulo.setPropietario(nil) 
    end

    
    def esDeMiPropiedad (titulo)
        return titulo.propietario == self;
    end

    public
    def estoyEnCalleLibre()
        raise NotImplementedError 
    end
    
    def getCartaLibertad()
        return @cartaLibertad 
    end
    
    def getCasillaActual()
        return @casillaActual
    end
    
    def getEncarcelado()
        return @encarcelado
    end
    
    def getNombre()
        return @nombre
    end
    
    def getPropiedades()
        return @propiedades
    end
    
    def getSaldo()
        return @saldo
    end
    
    def hipotecarPropiedad(titulo)
        costeHipoteca = titulo.hipotecar()
        modificarSaldo(costeHipoteca)
        return titulo.getHipotecada()
    end
    
    def irACarcel(casilla)
        setCasillaActual(casilla)
        setEncarcelado(true)
    end
    
    def modificarSaldo(cantidad)
        @saldo += cantidad
        return @saldo
    end
    
    def obtenerCapital()
        capital = @saldo;
        
        for t in @propiedades
            estaHipotecada = t.getHipotecada() ? 1 : 0
                    
            capital +=  t.getPrecioCompra() +
                        (t.getNumCasas() + t.getNumHoteles()) * t.getPrecioEdificar()
                        - estaHipotecada * t.getHipotecaBase()
        end
        
        return capital
    end
    
    def obtenerPropiedades(hipotecada)
        propiedadesDevolver = Array.new
        
        for t in @propiedades
            if (t.getHipotecada() == hipotecada)
                propiedadesDevolver << t         
            end
        end
        
        return propiedadesDevolver
    end
    
    def pagarAlquiler()
        costeAlquiler = @casillaActual.pagarAlquiler()
        modificarSaldo(-costeAlquiler)
    end
    
    def pagarImpuesto()
        modificarSaldo(-@casillaActual.getCoste())
    end
    
    def PagarLibertad(cantidad)
        tengoSaldo = tengoSaldo(cantidad)
        
        if tengoSaldo
            setEncarcelado(false)
            modificarSaldo(-cantidad)
        end
    end
    
    protected
    def puedoEdificarCasa(titulo)
        numCasas = titulo.getNumCasas()
        costeEdificar = titulo.getPrecioEdificar()
        edificable = false
        
        if (numCasas<4 && tengoSaldo(costeEdificar))
                edificable = true;

        end
        
        return edificable
    end
    
    def puedoEdificarHotel(titulo)
        numHoteles = titulo.getNumHoteles()
        costeEdificar = titulo.getPrecioEdificar()
        edificable = false
        
        if (numHoteles<4 && tengoSaldo(costeEdificar) && titulo.getNumCasas() >= 4)
                edificable = true
        end
        
        return edificable
    end
    
    public
    def setCartaLibertad(carta)
        @cartaLibertad = carta
    end
    
    def setCasillaActual(casilla)
        @casillaActual = casilla
    end
    
    def setEncarcelado(encarcelado)
        @encarcelado = encarcelado
    end
    
    def tengoCartaLibertad()
         @cartaLibertad != nil
    end
    
    private
    def tengoSaldo(cantidad)
        return @saldo > cantidad
    end
    
    public
    def venderPropiedad(casilla)
        precioVenta = 0
        titulo = casilla.getTitulo()
        eliminarDeMisPropiedades(titulo)
        precioVenta = titulo.calcularPrecioVenta()
        modificarSaldo(precioVenta)
        
        return casilla.tengoPropietario() 
    end

    def <=>(otroJugador)
    otroJugador.obtenerCapital <=> obtenerCapital
    end

    def to_s
        if (@cartaLibertad != nil)
            retorno = "Jugador{ encarcelado= #{@encarcelado} , nombre=
                    #{@nombre} , saldo= #{@saldo} , capital= #{obtenerCapital()}, cartaLibertad= 
                    #{@cartaLibertad} ,propiedades= " 
            for i in @propiedades        
            retorno += i.to_s()
            end
            
        else
             retorno = "Jugador{ encarcelado= #{@encarcelado} , nombre=
                #{@nombre} , saldo= #{@saldo} , capital= #{obtenerCapital()}, "
        
            for i in @propiedades        
                retorno += i.to_s()
            end
        end
        
        retorno += "casillaActual= #{@casillaActual} '}'"
        
        return retorno
    end
    
  end
end
