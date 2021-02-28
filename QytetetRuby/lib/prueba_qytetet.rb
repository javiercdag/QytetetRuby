#encoding: UTF-8
require_relative "sorpresa"
require_relative "qytetet"
require_relative "tipo_sorpresa"
require_relative "tablero"
require_relative "casilla"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "metodo_salir_carcel"

module ModeloQytetet
  class PruebaQytetet
    @@juego=Qytetet.instance
    
    def self.cartasMayorQueCero(mazo)
        
        @a_devolver = Array.new
        
        for t in mazo
          if (t.valor > 0)
            @a_devolver.push(t)
          end
        end
    
        @a_devolver;
    end
    
    def self.cartasIrACasilla(mazo)
        
        @a_devolver2 = Array.new
        tipo = TipoSorpresa::IRACASILLA
        
        for t in mazo
          if (t.tipo == tipo)
            @a_devolver2.push(t)
          end
        end
    
        @a_devolver2;
    end
    
    def self.cartasTipo(mazo, tipo)
        
        @a_devolver3 = Array.new
       
        for t in mazo
          if (t.tipo == tipo)
            @a_devolver3.push(t)
          end
        end
    
        @a_devolver3;
    end
    
    def self.imprimeMazo(mazo)
        for c in mazo
            puts c.to_s + "\n"
        end
        puts("\n");
    end
    
    def self.getNombreJugadores()
        puts "Introduce el numero de jugadores: \n"
        num_jugadores = gets.to_i
        nombres = Array.new
        
        num_jugadores.times  do
         puts("Introduzca el nombre del jugador:" )
         s = gets
         nombres << s
        end
        
        return nombres;
    end
  
    def self.main
      
        nombres = getNombreJugadores()
        @@juego.inicializarJuego(nombres)
=begin  mazo = @@juego.mazo
        m1 = Array.new
        m2 = Array.new
        m3 = Array.new
        
        imprimeMazo(mazo)
     
        m1 = cartasMayorQueCero(mazo)
        imprimeMazo(m1)
        
        m2 = cartasIrACasilla(mazo)
        imprimeMazo(m2)
        
        
        tipos = TipoSorpresa::constants
        
        for t in tipos
          m3 = cartasTipo(mazo,TipoSorpresa.const_get(t))
          imprimeMazo(m3)
        end
        
        puts @@juego.tablero.to_s + "\n"
=end       
        #puts @@juego.to_s
        puts ("A continuacion nos moveremos a una casilla de tipo calle")
      puts "\n"
      @@juego.mover(1)
      puts("Ahora probaremos a comprarla")
      puts "\n"
      comprada = @@juego.comprarTituloPropiedad()

      if (comprada)
        puts ("La calle ha sido comprada")
        puts "\n"

      else
        puts ("La calle no pudo ser comprada")
        puts "\n"
      end

      puts ("Ahora nos moveremos a una calle de tipo impuesto y luego a una de tipo sorpresa")
      puts "\n"
      @@juego.mover(17)
      @@juego.mover(3)
      @@juego.aplicarSorpresa()

      puts ("A continuacion haremos que el primer jugador compre la casilla 10")
      puts "\n"
      @@juego.mover(10)
      @@juego.comprarTituloPropiedad()

      puts "Ahora, como especulador, comprará 8 casas."
      
      for i in 1..8
            @@juego.edificarCasa(10);
      end
            
      @@juego.siguienteJugador();
      puts ("Ahora moveremos al siguiente jugador a esa casilla")
      puts "\n"
      puts ("El saldo actual del segundo es #{@@juego.getJugadorActual().getSaldo()}")
      puts "\n"

      @@juego.mover(10)
      @@juego.getJugadorActual().pagarAlquiler()

      puts ("Al tener que pagar el alquiler su saldo se reduce a #{@@juego.getJugadorActual().getSaldo()}")
      puts "\n"

      puts ("A continuacion se hipotecara la propiedad de la casilla 10")
      puts "\n"
      @@juego.hipotecarPropiedad(10)
      puts ("A continuacion se edificara una casa y un hotel en esta casilla")
      puts "\n"
      @@juego.edificarCasa(10)
      @@juego.edificarHotel(10)
      puts ("El numero de casas ahora es #{@@juego.tablero.obtenerCasillaNumero(10).titulo.numCasas}")
      puts "\n"
      puts ("El numero de hoteles ahora es #{@@juego.tablero.obtenerCasillaNumero(10).titulo.numHoteles}")
      puts "\n"

      puts ("Ahora cancelare la hipoteca")
      puts "\n"
      @@juego.cancelarHipoteca(10)
      puts ("Ahora intentaremos salir de la carcel tirando un dado")
      puts "\n"
      
      @@juego.getJugadorActual().setEncarcelado(true);
      salir_carcel = @@juego.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
      puts "Has sacado un #{@@juego.getValorDado()}"

      if (!salir_carcel)
        puts("Has salido de la carcel")
        puts "\n"

      else
        puts ("No has salido de la carcel")
        puts "\n"
      end
      
      @@juego.obtenerRanking();
      puts("El ranking es:\n")
      
      for n in @@juego.getJugadores()
        puts("#{n.to_s()}\n")
      end
      
      @@juego.mover(11);
        
      for n in @@juego.getMazo()
           puts n.to_s + "\n"
      end
      

     puts "TRAS ACTUAR, NUEVA SITUACION:"

      @@juego.actuarSiEnCasillaNoEdificable();

      for n in @@juego.getMazo()
           puts n.to_s + "\n"
      end
      
    end
  
  PruebaQytetet.main()
  end
end

