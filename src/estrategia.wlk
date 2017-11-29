import companero.*
import summer.*
import jerry.*
import humor.*
import rick.*
import material.*
import experimento.*

class Estrategia {
	
	method seleccionarMaterial(mochila)

	}
	
object alAzar inherits Estrategia{
				
	override method seleccionarMaterial(mochila) =  mochila.anyOne()
	
	}
	
object menorCantidadDeMetal inherits Estrategia{
		
	override method seleccionarMaterial(mochila) =  mochila.min({elemento => elemento.gramosMetal()})	

	}
	
object mejorGeneradorElectrico inherits Estrategia{
		
		
	override method seleccionarMaterial(mochila) = mochila.max({elemento => elemento.energiaProducida()})
	
	}
	
object ecologico inherits Estrategia{
	
	
	override method seleccionarMaterial(mochila){
	
		return mochila.findOrElse({elemento => elemento.esUnSerVivo()}, {mochila.findOrDefault({elemento => !elemento.esRadiactivo()},mochila.anyOne())})
	}
}