import companero.*
import experimento.*
import estrategia.*
import wollok.game.*

object rick{
	
	var mochila = #{}
	var experimentos =[construirBateria,construirCircuito,construirShockElectrico]
	var companero = morty
	var estrategia = alAzar	
	
	method imagen() = "rick.jpeg"
	
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
		unExperimento.efectoDeCreacion(self)
		self.agregarMaterial(self.materialConstruidoSegunExperimento(unExperimento))
		mochila.removeAll(self.materialesSegunExperimento(unExperimento))
		
	}
	
}	
	
	