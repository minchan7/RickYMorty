import companero.*
import experimento.*
import estrategia.*

object rick{
	
	var mochila = #{}
	var experimentos = #{construirBateria,construirCircuito,construirShockElectrico}
	var companero = morty
	var estrategia = alAzar
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	method agregarMaterial(unMaterial){
		mochila.add(unMaterial)
	}
	
	method experimentosQuePuedeRealizar() = experimentos.filter({experimento => experimento.cumpleRequisitoParaSerCreado(mochila)})
	
	
	method realizar(unExperimento){	
		if(!unExperimento.cumpleRequisitoParaSerCreado(mochila)){
			self.error("No puedo realizar el experimento")
		}
		self.efectoDeRealizarExperimento(unExperimento)
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

	// TODO Este código es muy difícil de leer, parece inconsistente, a la izquierda "materiales" parece que va a devolver una lista
	// a la derecha "cumpleCon..." parece que va a devolver un booleano.
	
	method materialesSegunExperimento(experimento) = experimento.materialesUsadosParaCreacion(mochila,estrategia)
	
	method materialConstruidoSegunExperimento(experimento) = experimento.materialConstruido(mochila,estrategia)
	
	method efectoDeRealizarExperimento(unExperimento) {
		unExperimento.efectoDeCreacion(self)
		mochila.removeAll(self.materialesSegunExperimento(unExperimento))
		self.agregarMaterial(self.materialConstruidoSegunExperimento(unExperimento))
	}
	
	
	
}	
	
	