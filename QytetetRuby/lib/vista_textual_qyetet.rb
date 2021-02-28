require_relative "qytetet"
require_relative "opcion_menu"
require_relative "controlador_qytetet"

module Vistatextualqytetet
  class VistaTextualQytetet
    include Controladorqytetet
    include ModeloQytetet
    
    @@controlador = ControladorQytetet.instance
    
    def obtenerNombreJugadores()
        modelo = Qytetet.instance
        valoresCorrectos = Array.new
        nombreJugadores = Array.new
        num_jugadores = 0
        
        
        for i in 2 .. modelo.getMAX_JUGADORES
            valoresCorrectos << i
        end
        
        puts "Introduce el numero de jugadores:\n"
        num_jugadores = leerValorCorrecto(valoresCorrectos)
        
        for i in 1..num_jugadores
            puts "Introduce el nombre del jugador #{i}:\n"
            s = gets
            nombreJugadores << s
        end
        
        return nombreJugadores
    end
    
    
    def leerValorCorrecto(valoresCorrectos)
      pos = nil

      while pos == nil
            introducido = gets.to_i

            for i in 0..valoresCorrectos.size
              if (introducido == valoresCorrectos[i].to_i)
                pos = i
                break
              end
            end

            if (pos == nil)
                puts "\nEl valor introducido no es correcto\n"
            end
      end

       return valoresCorrectos[pos]
    end
    
    
    def elegirCasilla(opcionMenu)
        casillasValidas = @@controlador.obtenerCasillasValidas(opcionMenu)
        casillasValidasString = Array.new
        if (casillasValidas.size() == 0)
            puts "\nNo hay casillas posibles\n\n"
            return -1;
        else
            for i in casillasValidas
                casillasValidasString << i.to_s
            end
            
            puts "Casillas posibles: "

            for i in casillasValidas
                puts "[#{i}]"
            end

            puts "\n"
        end
        
        return leerValorCorrecto(casillasValidasString).to_i
    end
    
    def elegirOperacion()
        operacionesValidas = @@controlador.obtenerOperacionesJuegoValidas()
        operacionesValidasString = Array.new
        
        for i in operacionesValidas
            operacionesValidasString << i.to_s
        end
        
        puts "Las operaciones que puede elegir son: "
        
        for i in operacionesValidasString
            puts "#{i} #{OpcionMenu[i.to_i]}"
        end
        
        return leerValorCorrecto(operacionesValidasString).to_i
    end
    
    def self.main
        ui = VistaTextualQytetet.new
        @@controlador.setNombreJugadores(ui.obtenerNombreJugadores)
        casillaElegida = 0;

        while (true)
            operacionElegida = ui.elegirOperacion
            necesitaElegirCasilla = @@controlador.necesitaElegirCasilla(operacionElegida)
            if (necesitaElegirCasilla)
                casillaElegida = ui.elegirCasilla(operacionElegida)
            end
            if (!necesitaElegirCasilla || casillaElegida >= 0)
                puts @@controlador.realizarOperacion(operacionElegida,casillaElegida)
            end
        end
    end
    
    VistaTextualQytetet.main()
  end
end
