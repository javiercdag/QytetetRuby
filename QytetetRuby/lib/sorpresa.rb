#encoding: UTF-8
module ModeloQytetet
  class Sorpresa

    attr_accessor:texto
    attr_accessor:tipo
    attr_accessor:valor
    
    def initialize (text, value, type)
        @texto = text
        @tipo = type
        @valor = value
    end
    
    def getTipo()
      return @tipo
    end
    
    def getTexto()
      return @texto
    end
    
    def getValor
      return @valor
    end
    
    def self.newSalirCarcel(text)
      self.new(text, 1, TipoSorpresa::SALIRCARCEL)
      
    end

    def to_s
        "Texto: #{@texto} \n Valor: #{@valor} \n Tipo: #{@tipo}"
    end 


  end
end