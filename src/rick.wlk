import companero.*
import experimento.*
import estrategia.*
import wollok.game.*
import contenedor.*

object rick{
	
	var mochila = []
	var experimentos =[construirBateria,construirCircuito,construirShockElectrico]
	var companero = morty
	var estrategia = alAzar	
	
	var posicion = new Position(2,2)
	var experimentosVisuales = experimentos.forEach{experimento => experimentosRick.guardar(experimento)}
	
	method posicion() = posicion
	 
	method cambiarPosicion(_posicion){posicion = _posicion}
	
	method imagen() = "rick.jpeg"
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
		unosMateriales.forEach{material => mochilaRick.guardar(material)}
	}
	
	method agregarMaterial(unMaterial){
		mochila.add(unMaterial)
	}
	
	method experimentosQuePuedeRealizar() = experimentos.filter({experimento => experimento.cumpleRequisitoParaSerCreado(mochila)})
	
	
	method realizar(unExperimento){	
		if(!unExperimento.cumpleRequisitoParaSerCreado(mochila)){
			self.error("No puedo realizar el experimento")
		}
		else self.efectoDeRealizarExperimento(unExperimento)
	}
	
	method cambiarCompanero(unCompanero){
		companero = unCompanero
	}
	
	method agregarExperimento(unExperimento){
		experimentos.add(unExperimento)
	}
	
	method companero() = companero
	
	method mochila() = mochila
	
	method cambiarEstrategia(_unaEstrategia){
		estrategia = _unaEstrategia
	}
	
	method estrategia() = estrategia
	
	method materialesSegunExperimento(experimento) = experimento.materialesUsadosParaCreacion(mochila,estrategia)
	
	method materialConstruidoSegunExperimento(experimento) = experimento.materialConstruido(mochila,estrategia)
	
	method efectoDeRealizarExperimento(unExperimento) {
		var materiales = self.materialesSegunExperimento(unExperimento) 
		
		unExperimento.efectoDeCreacion(self,materiales)
		self.materialesSegunExperimento(unExperimento).forEach{material => mochilaRick.sacar(material)}
		mochila.removeAll(materiales)
		
	}
	
}	
	
	