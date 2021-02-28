#encoding: UTF-8
require_relative "dado"
require_relative "jugador"
require_relative "tablero"
require_relative "sorpresa"
require_relative "tipo_sorpresa"
require_relative "estado_juego"
require "singleton"

module ModeloQytetet
  class Qytetet
    
    include Singleton
    
    attr_accessor:mazo
    attr_accessor:cartaActual
    attr_reader:tablero
    attr_reader:dado
    attr_reader:jugadores
    attr_reader:mazo
    attr_reader:jugadorActual
    
    
    @@MAX_JUGADORES = 4;
    @@NUM_CASILLAS = 20;
    @@NUM_SORPRESAS = 12;
    @@PRECIO_LIBERTAD = 200;
    @@SALDO_SALIDA = 1000;
    
    def initialize
      @mazo = Array.new
      @jugadorActual = nil
      @jugadores = Array.new
      @dado = Dado.instance
      @cartaActual = nil
      @indiceJugadorActual = 0
      @estadoJuego = nil
    end
    
    #@@instance = new
    

    def actuarSiEnCasillaEdificable()
      deboPagar = @jugadorActual.deboPagarAlquiler()
        
        if deboPagar
            @jugadorActual.pagarAlquiler()
        end
        
        tengoPropietario = obtenerCasillaJugadorActual().tengoPropietario()
        
        if tengoPropietario
            setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        else
            setEstadoJuego(EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
        end
    end 
    
    def actuarSiEnCasillaNoEdificable()
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        casillaActual = @jugadorActual.getCasillaActual()
        
        if (casillaActual.tipo == TipoCasilla::IMPUESTO)
            @jugadorActual.pagarAlquiler()  
        elsif (casillaActual.tipo == TipoCasilla::JUEZ)
                encarcelarJugador()
        elsif (casillaActual.tipo == TipoCasilla::SORPRESA)
                @cartaActual = @mazo.shift()
                setEstadoJuego(EstadoJuego::JA_CONSORPRESA)
        end
    end 
    
    def aplicarSorpresa()
      setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        
        if @cartaActual.getTipo() == TipoSorpresa::SALIRCARCEL
            @jugadorActual.setCartaLibertad(@cartaActual);
        end
        
        @mazo << @cartaActual
        
        if @cartaActual.getTipo() == TipoSorpresa::PAGARCOBRAR
            @jugadorActual.modificarSaldo(@cartaActual.getValor())
            
            if @jugadorActual.getSaldo()<0
                setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
            end
            
        elsif @cartaActual.getTipo() == TipoSorpresa::IRACASILLA
            valor = @cartaActual.getValor();
            casillaCarcel = @tablero.esCasillaCarcel(valor);
            
            if casillaCarcel
                encarcelarJugador()
            else
                mover(valor)
            end
            
        elsif @cartaActual.getTipo() == TipoSorpresa::PORCASAHOTEL
            cantidad = @cartaActual.getValor()
            numeroTotal = @jugadorActual.cuantasCasasHotelesTengo()
            @jugadorActual.modificarSaldo(cantidad*numeroTotal)
            
            if (@jugadorActual.getSaldo()<0)
                setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA)
            end
            
        elsif @cartaActual.getTipo() == TipoSorpresa::PORJUGADOR
            for i in @@MAX_JUGADORES
                jugador = @jugadores[i]
                
                if (jugador != @jugadorActual)
                    jugador.modificarSaldo(-@cartaActual.getValor());
                end
                
                if (jugador.getSaldo()<0)
                    setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA);
                end
                
                @jugadorActual.modificarSaldo(@cartaActual.getValor());
                
                if (@jugadorActual.getSaldo()<0)
                    setEstadoJuego(EstadoJuego::ALGUNJUGADORENBANCARROTA);    
                end
            end
        elsif @cartaActual.getTipo() == TipoSorpresa::CONVERTIRME
            posicionJugadorActual = @jugadores.index(@jugadorActual)
            nuevo = @jugadorActual.convertirme(@cartaActual.getValor())
            puts nuevo.to_s
            @jugadores[posicionJugadorActual] = nuevo
            @jugadorActual = @jugadores[posicionJugadorActual]
        end
    end 
    
    def cancelarHipoteca(numeroCasilla)
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
        titulo = casilla.getTitulo()
        cancelada = @jugadorActual.cancelarHipoteca(titulo)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        
        return cancelada
    end 
    
    def comprarTituloPropiedad()
      comprado = @jugadorActual.comprarTituloPropiedad()
        
        if comprado
            setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        end
        
        return comprado
    end 
    
    def edificarCasa(numeroCasilla)
        edificada = false
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
        titulo = casilla.getTitulo()
        edificada = @jugadorActual.edificarCasa(titulo)
        
        if edificada
            setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        end
        
        return edificada
    end 
    
    def edificarHotel(numeroCasilla)
        edificada = false
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
        titulo = casilla.getTitulo()
        edificada = @jugadorActual.edificarHotel(titulo)
        
        if edificada
            setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
        end
        
        return edificada
    end 
    
    def encarcelarJugador()
      if @jugadorActual.deboIrACarcel()
            casillaCarcel = @tablero.getCarcel()
            @jugadorActual.irACarcel(casillaCarcel)
            setEstadoJuego(EstadoJuego::JA_ENCARCELADO)
      else
            carta = @jugadorActual.devolverCartaLibertad()
            @mazo << carta
            setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
      end
    end 
    
    def getEstadoJuego()
      return @estadoJuego
    end
    
    def getJugadores()
      return @jugadores
    end
    
    def getMAX_JUGADORES
      return @@MAX_JUGADORES
    end
    
    def getMazo()
      return @mazo
    end
    
    def getCartaActual()
      return @cartaActual
    end
    
    def getTablero()
      return @tablero
    end
    
    def getJugadorActual()
      return @jugadorActual
    end
    
    def getValorDado()
      return @dado.valor
    end 
    
    def hipotecarPropiedad(numeroCasilla)
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
        titulo = casilla.titulo()
        @jugadorActual.hipotecarPropiedad(titulo)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR)
    end 
    
    def inicializarCartasSorpresa
        @mazo << Sorpresa.new("¡Te convierte en un ESPECULADOR! (3000 fianza)", 3000, TipoSorpresa::CONVERTIRME)
        @mazo << Sorpresa.new("¡Te convierte en un ESPECULADOR! (5000 fianza)", 5000, TipoSorpresa::CONVERTIRME)
        @mazo << Sorpresa.new("Muy valiosa para unos, no tanto para otros, úsala sabiamente: sal de la carcel", 1, TipoSorpresa::SALIRCARCEL)
        @mazo << Sorpresa.new("Fuíste demasiado rápido con el coche a la, última reunión, has de pagar 300 euros.", -300, TipoSorpresa::PAGARCOBRAR) 
        @mazo << Sorpresa.new("Has conseguido 600 euros", 600, TipoSorpresa::PAGARCOBRAR)
        @mazo << Sorpresa.new("Han subido los impuestos sobre propiedades, has de pagar 100 por cada casa de tu propiedad.", -100, TipoSorpresa::PORCASAHOTEL)
        @mazo << Sorpresa.new("Cobra 150 euros por cada casa", 150, TipoSorpresa::PORCASAHOTEL)
        @mazo << Sorpresa.new("Tus competidores te reclaman dinero y ganan en los tribunales, paga 200 euros a cada uno.", -200, TipoSorpresa::PORJUGADOR)
        @mazo << Sorpresa.new("Cada jugador te da 200 euros", 200, TipoSorpresa::PORJUGADOR)
        @mazo << Sorpresa.new("Esta temporada vacacional va algo lenta, vuelve a la salida y cobra!", 0, TipoSorpresa::IRACASILLA)
        @mazo << Sorpresa.new("Vas a la cárcel", 9, TipoSorpresa::IRACASILLA)
        @mazo << Sorpresa.new("Avanza hasta la casilla 5", 0, TipoSorpresa::IRACASILLA)
        @mazo = @mazo.shuffle
    end
    
    def inicializarJuego(nombres)
        inicializarJugadores(nombres)
        inicializarTablero()
        inicializarCartasSorpresa()
        salidaJugadores()
        @cartaActual = @mazo[0]  
    end
    
    private
    def inicializarJugadores(nombres)
        for n in nombres
            @jugadores << Jugador.nuevo(n)
        end
    end

    def inicializarTablero
      @tablero = Tablero.new
    end
    
    public
    def getTablero
        return tablero #esto no lo pone UML
    end
    
    def getJugadorActual
        return @jugadorActual #esto no lo pone UML
    end
    
    def intentarSalirCarcel(metodo)
        
        if metodo == MetodoSalirCarcel::TIRANDODADO
            resultado = tirarDado()
            
            if resultado >= 5
                @jugadorActual.setEncarcelado(false)
            end
            
        elsif metodo == MetodoSalirCarcel::PAGANDOLIBERTAD
            @jugadorActual.PagarLibertad(@@PRECIO_LIBERTAD)
        end
        
        encarcelado = @jugadorActual.getEncarcelado()
        
        if encarcelado
            setEstadoJuego(EstadoJuego::JA_ENCARCELADO)
        else
            setEstadoJuego(EstadoJuego::JA_PREPARADO)
        end
        
        return !encarcelado
    end 
    
    def jugar()
      valor = tirarDado()
      mover(@tablero.obtenerCasillaFinal(@jugadorActual.getCasillaActual().getNumeroCasilla(), valor).getNumeroCasilla())
    end 
    
    def mover(numCasillaDestino)
        casillaInicial = @jugadorActual.getCasillaActual()
        casillaFinal = @tablero.obtenerCasillaNumero(numCasillaDestino)
        @jugadorActual.setCasillaActual(casillaFinal)
        
        if numCasillaDestino < casillaInicial.numeroCasilla
            @jugadorActual.modificarSaldo(@@SALDO_SALIDA)
        end
        
        if casillaFinal.soyEdificable()
            actuarSiEnCasillaEdificable()
        else
            actuarSiEnCasillaNoEdificable()
        end
    end 
    
    def obtenerCasillaJugadorActual()
       return @jugadorActual.getCasillaActual()
    end 
    
    def obtenerCasillasTablero()
      raise NotImplementedError 
    end 
    
    def obtenerPropiedadesJugador()
      propiedadesDevolver = Array.new
      propiedadesJugador = @jugadorActual.getPropiedades()

      for c in @tablero.getCasillas()
          if c.getTipo() == TipoCasilla::CALLE
            if propiedadesJugador.include?(c.getTitulo())
                propiedadesDevolver << c.getNumeroCasilla()
            end
          end
      end

      return propiedadesDevolver
    end 
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      propiedadesDevolver = Array.new
      propiedadesJugador = @jugadorActual.obtenerPropiedades(estadoHipoteca);

      for c in @tablero.getCasillas()
          if c.getTipo() == TipoCasilla::CALLE
            if propiedadesJugador.include? c.getTitulo()
                propiedadesDevolver << c.getNumeroCasilla()
            end
          end
      end

      return propiedadesDevolver
    end 
    
    def obtenerRanking()
      @jugadores = @jugadores.sort 
    end 
    
    def obtenerSaldoJugadorActual()
      return @jugadorActual.getSaldo()
    end 
    
    private
    def salidaJugadores()
      @indiceJugadorActual = rand(@jugadores.size())
      @jugadorActual = @jugadores[@indiceJugadorActual]
      
      for n in @jugadores
            n.setCasillaActual(@tablero.casillas[0]);
      end
            
      setEstadoJuego(EstadoJuego::JA_PREPARADO)
    end
    
    def setCartaActual (cartaActual)
        @cartaActual = cartaActual
    end
    
    public
    
    def setEstadoJuego(estado)
        @estadoJuego = estado
    end
    
    def siguienteJugador()
      @indiceJugadorActual = (@indiceJugadorActual+1) % @jugadores.size();
      @jugadorActual = @jugadores[@indiceJugadorActual]
        
      if (@jugadorActual.getEncarcelado())
          @estadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
          @estadoJuego = EstadoJuego::JA_PREPARADO
      end
    end        
    
    def tirarDado()
      return @dado.tirar()
    end
    
    def venderPropiedad(numeroCasilla)
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
        @jugadorActual.venderPropiedad(casilla)
        setEstadoJuego(EstadoJuego::JA_PUEDEGESTIONAR) 
    end
    
    def to_s
        retorno = "Qytetet{ MAX_JUGADORES= #{@@MAX_JUGADORES} , NUM_SORPRESAS= #{@@NUM_SORPRESAS},
                NUM_CASILLAS= #{@@NUM_CASILLAS}, PRECIO_LIBERTAD= #{@@PRECIO_LIBERTAD},
                SALDO_SALIDA= #{@@SALDO_SALIDA}, jugadorActual= #{@jugadorActual.to_s},
                cartaActual= #{@cartaActual.to_s}, dado= #{@dado.to_s}, tablero= #{@tablero.to_s},"
      
      retorno += "\n Jugadores = {"
      for n in @jugadores
          retorno += n.to_s
      end
      
      retorno += "}\n Mazo = {"
      
      for n in @mazo
          retorno += n.to_s
      end
      
      retorno += "}}"
    end
    
  end
end
