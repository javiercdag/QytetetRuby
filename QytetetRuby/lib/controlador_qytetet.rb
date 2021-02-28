require_relative "qytetet"
require_relative "Metodo_Salir_Carcel"
require_relative "opcion_menu"
require_relative "estado_juego"
require "singleton"
  
module Controladorqytetet
  class ControladorQytetet
    include Singleton
    include ModeloQytetet
    @@num_jugadores = 0
    
    def initialize()
      @modelo = Qytetet.instance
      @nombreJugadores = Array.new
    end
    
    #@@instance = new
    
    def setNombreJugadores(nombreJugadores)
        @nombreJugadores = nombreJugadores
    end
    
    def obtenerOperacionesJuegoValidas()
        operaciones = Array.new
        
        if @modelo.getJugadores().size() == 0
            operaciones << OpcionMenu.index(:INICIARJUEGO)
        else
            if @modelo.getEstadoJuego() == EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
                operaciones << OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
                operaciones << OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
                operaciones << OpcionMenu.index(:PASARTURNO)
            elsif @modelo.getEstadoJuego() == EstadoJuego::JA_ENCARCELADO
                operaciones << OpcionMenu.index(:PASARTURNO)
            elsif @modelo.getEstadoJuego() == EstadoJuego::JA_PREPARADO
                operaciones << OpcionMenu.index(:JUGAR)
            elsif @modelo.getEstadoJuego() == EstadoJuego::ALGUNJUGADORENBANCARROTA
                operaciones << OpcionMenu.index(:OBTENERRANKING)
            elsif @modelo.getEstadoJuego() == EstadoJuego::JA_CONSORPRESA
                operaciones << OpcionMenu.index(:APLICARSORPRESA)
            elsif @modelo.getEstadoJuego() == EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
                operaciones << OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
                operaciones << OpcionMenu.index(:VENDERPROPIEDAD)
                operaciones << OpcionMenu.index(:HIPOTECARPROPIEDAD)
                operaciones << OpcionMenu.index(:CANCELARHIPOTECA)
                operaciones << OpcionMenu.index(:EDIFICARCASA)
                operaciones << OpcionMenu.index(:EDIFICARHOTEL)
                operaciones << OpcionMenu.index(:PASARTURNO)
            elsif @modelo.getEstadoJuego() == EstadoJuego::JA_PUEDEGESTIONAR
                operaciones << OpcionMenu.index(:VENDERPROPIEDAD)
                operaciones << OpcionMenu.index(:HIPOTECARPROPIEDAD)
                operaciones << OpcionMenu.index(:CANCELARHIPOTECA)
                operaciones << OpcionMenu.index(:EDIFICARCASA)
                operaciones << OpcionMenu.index(:EDIFICARHOTEL)
                operaciones << OpcionMenu.index(:PASARTURNO)
            end
            
            operaciones << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
            operaciones << OpcionMenu.index(:MOSTRARJUGADORES)
            operaciones << OpcionMenu.index(:MOSTRARTABLERO)
            operaciones << OpcionMenu.index(:TERMINARJUEGO)
        end
        
        return operaciones
    end
    
    def necesitaElegirCasilla(opcionMenu)
        a_devolver = false
        
        if (opcionMenu == OpcionMenu.index(:HIPOTECARPROPIEDAD) ||
           opcionMenu == OpcionMenu.index(:CANCELARHIPOTECA) ||
           opcionMenu == OpcionMenu.index(:EDIFICARCASA) ||
           opcionMenu == OpcionMenu.index(:EDIFICARHOTEL) ||
           opcionMenu == OpcionMenu.index(:VENDERPROPIEDAD))
            a_devolver = true
        
        return a_devolver
        
        end
    end
    
    def obtenerCasillasValidas(opcionMenu)
        opcion = OpcionMenu[opcionMenu]
        a_devolver = Array.new
        
        if opcion == :CANCELARHIPOTECA
            a_devolver = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true)
        elsif (opcion == :HIPOTECARPROPIEDAD)
            a_devolver = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
        elsif (opcion == :EDIFICARCASA || opcion == :EDIFICARHOTEL)
            a_devolver = @modelo.obtenerPropiedadesJugador()
        elsif (opcion == :VENDERPROPIEDAD)
            a_devolver = @modelo.obtenerPropiedadesJugador()
        end
        
        return a_devolver;
    end
    
    
    def realizarOperacion(opcionElegida, casillaElegida)
        opcion = OpcionMenu[opcionElegida]
        a_devolver = ""
        
        if opcion == :INICIARJUEGO
            a_devolver = "Los nombres con los que se inicializa el juego son:\n #{@nombreJugadores.to_s} \n"
            @modelo.inicializarJuego(@nombreJugadores)
            a_devolver += "El jugador que empieza es: #{@modelo.getJugadorActual().to_s} \n"
            
        elsif opcion == :APLICARSORPRESA
            a_devolver = "La carta aplicada es:\n #{@modelo.getCartaActual().to_s}"
            @modelo.aplicarSorpresa()
            
        elsif opcion == :CANCELARHIPOTECA
            if @modelo.cancelarHipoteca(casillaElegida)
                a_devolver = "Se ha cancelado la hipoteca de la casilla #{casillaElegida}\n"
            else
                a_devolver = "No se ha podido cancelar la hipoteca de la casilla #{casillaElegida}\n"
            end
            
        elsif opcion == :COMPRARTITULOPROPIEDAD
            if @modelo.comprarTituloPropiedad()
                a_devolver = "Se ha comprado la casilla\n"
            else
                a_devolver = "No se ha podido comprar la casilla\n"
            end
            
        elsif opcion == :EDIFICARCASA
            if @modelo.edificarCasa(casillaElegida)
                a_devolver = "Se ha edificado una casa en la casilla #{casillaElegida}\n"
            else
                a_devolver = "No se ha podido edificar la casa en la casilla #{casillaElegida}\n"
            end 
            
        elsif opcion == :EDIFICARHOTEL
            if @modelo.edificarHotel(casillaElegida)
                a_devolver = "Se ha edificado un hotel en la casilla #{casillaElegida}\n"
            else
                a_devolver = "No se ha podido edificar el hotel en la casilla #{casillaElegida}\n"
            end

        elsif opcion == :HIPOTECARPROPIEDAD
            if @modelo.hipotecarPropiedad(casillaElegida)
                a_devolver = "Se ha hipotecado la casilla #{casillaElegida}\n"
            else
                a_devolver = "No se ha podido hipotecar la casilla #{casillaElegida}\n";
            end

        elsif opcion == :INTENTARSALIRCARCELPAGANDOLIBERTAD
            if @modelo.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
                a_devolver = "Has salido de la carcel pagando por tu libertad.\n"
            else
                a_devolver = "No has salido de la carcel pagando por tu libertad.\n"
            end
            
        elsif opcion == :INTENTARSALIRCARCELTIRANDODADO
            if @modelo.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
                a_devolver = "Has salido de la carcel porque el RNG estaba de tu lado"
            else
                a_devolver = "Unlucky. No has salido de la carcel.\n"
            end
            
        elsif opcion == :JUGAR
            @modelo.jugar()
            a_devolver = "Al tirar el dado sacas un #{@modelo.getValorDado()} lo que te lleva a la casilla #{@modelo.obtenerCasillaJugadorActual().to_s}\n"

        elsif opcion == :MOSTRARJUGADORACTUAL
            a_devolver = @modelo.getJugadorActual().to_s
            
        elsif opcion == :MOSTRARJUGADORES
          
            for j in @modelo.getJugadores()
              a_devolver = a_devolver + j.to_s
              a_devolver = a_devolver + "\n"
            end
            
        elsif opcion == :MOSTRARTABLERO
            a_devolver = @modelo.getTablero().to_s
            
        elsif opcion == :PASARTURNO
            @modelo.siguienteJugador();
            a_devolver = "Pasas el turno. Ahora le toca jugar a #{@modelo.getJugadorActual().to_s}\n"
  
        elsif opcion == :TERMINARJUEGO
            @modelo.obtenerRanking()
            
            for j in @modelo.getJugadores
              a_devolver = a_devolver + j.to_s
              a_devolver = a_devolver + "\n"
            end
            
            puts "#{a_devolver}"
            puts "\n ------------------------ \n Gracias por jugar!!! \n ------------------------ \n"
            exit
       
        elsif opcion == :VENDERPROPIEDAD
            if @modelo.venderPropiedad(casillaElegida)
                a_devolver = "Se ha vendido la propiedad de la casilla #{casillaElegida}\n"
            else
                a_devolver = "No se ha podido vender la propiedad de la casilla #{casillaElegida}\n"
            end
        end
        
        return a_devolver
    end
  end
end
