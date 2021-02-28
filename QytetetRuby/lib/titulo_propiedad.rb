#encoding: UTF-8
module ModeloQytetet
  class TituloPropiedad
    attr_reader:nombre
    attr_reader:precioCompra
    attr_reader:alquilerBase
    attr_reader:factorRevalorizacion
    attr_reader:hipotecaBase
    attr_reader:precioEdificar
    attr_reader:numHoteles
    attr_reader:numCasas
    attr_accessor:hipotecada
    attr_accessor:propietario

    
    def initialize(nombre, precioCompra, alquilerBase, factorRevalorizacion,
                   hipotecaBase, precioEdificar)
      @nombre = nombre
      @precioCompra = precioCompra
      @alquilerBase = alquilerBase
      @factorRevalorizacion = factorRevalorizacion
      @hipotecaBase = hipotecaBase
      @precioEdificar = precioEdificar
      @numHoteles = 0
      @numCasas = 0
      @hipotecada = false
      @propietario = nil
    end

    def calcularCosteCancelar()
      return (11/10 * calcularCosteHipotecar()).to_i
    end
    
    def calcularCosteHipotecar()
        costeHipoteca = (@hipotecaBase + @numCasas*0.5*@hipotecaBase + @numHoteles*@hipotecaBase).to_i
        return costeHipoteca
    end
    
    def calcularImporteAlquiler()
      return (@alquilerBase + (@numCasas*0.5+@numHoteles*2).to_i)
    end
    
    def calcularPrecioVenta()
        precioVenta = (@precioCompra + (@numCasas+@numHoteles)*@precioEdificar*@factorRevalorizacion).to_i
        return precioVenta
    end
    
    def cancelarHipoteca()
      @hipotecada = false
    end
    
    def cobrarAlquiler (coste)
      @propietario.modificarSaldo(-coste);
    end
    
    def edificarCasa()
      @numCasas = @numCasas+1
    end
    
    def edificarHotel()
      @numCasas = @numCasas - 4
      @numHoteles = @numHoteles + 1
    end
    
    def getHipotecaBase()
      return @hipotecaBase
    end
    
    def getHipotecada()
      return @hipotecada
    end
    
    def getNumCasas()
      return @numCasas
    end
    
    def getNumHoteles()
        return @numHoteles
    end
    
    def getPrecioCompra()
      return @precioCompra
    end
    
    def getPrecioEdificar()
      return @precioEdificar
    end
    
    def getPropietario()
        return @propietario
    end
    
    def hipotecar()
      @hipotecada = true
      costeHipoteca = calcularCosteHipotecar()
        
      return costeHipoteca
    end 
    
    def pagarAlquiler()
      costeAlquiler = calcularImporteAlquiler()
      @propietario.modificarSaldo(costeAlquiler)
      return costeAlquiler
    end 
    
    def propietarioEncarcelado()
      return @propietario.getEncarcelado()
    end
    
    def setPropietario(propietario)
      @propietario = propietario
    end
    
    def tengoPropietario()
        if (@propietario != nil)
            return true;
        else
            return false;
        end
    end
    
    def to_s
        retorno = "TituloPropiedad nombre= #{@nombre}, hipotecada= #{@hipotecada},
                precioCompra= #{@precioCompra}, alquilerBase= #{@alquilerBase},
                factorRevalorizacion= #{@factorRevalorizacion},
                hipotecaBase= #{@hipotecaBase}, precioEdificar= #{@precioEdificar},
                numHoteles= #{@numHoteles}, numCasas= #{@numCasas}"
        if (@propietario != nil)
            retorno += ", propietario{
                encarcelado= #{@propietario.getEncarcelado()}, nombre= 
                #{@propietario.getNombre()}, saldo= #{@propietario.getSaldo()}"
            
            if (@propietario.getCartaLibertad() != nil)
                retorno += ", cartaLibertad= #{@propietario.getCartaLibertad()}"
            end
        end
        
        
        retorno += "}\n}";
        
        return retorno;
    end
  end
end
