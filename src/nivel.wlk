import wollok.game.*
import pared.*
import companero.*
import rick.*
import materialesBasicos.*
import experimento.*
import celda.*


object nivel {

	method configurate(_largo,_ancho){
	//	CONFIGURACION	
		game.title("RickYMorty")
		game.height(_largo)
		game.width(_ancho)
		game.ground("suelo.jpg")
		morty.energiaInicial(2000)
		
	//	VISUALES
	 	const materialesBasicos = [lata,fleeb,cable,materiaOscura,parasitoAlienigena]//ConjuntoDeMaterialesBasicos
	 	
	 	materialesBasicos.forEach{materiales => game.addVisual(materiales)}
	 	
	 	game.addVisual(rick)
		game.addVisualCharacter(morty)
	
	// ACCIONES
		
		R.onPressDo { 
			materialesBasicos.forEach { material => 
				if(rick.companero().posicion() == material.posicion()) {
					rick.companero().recolectar(material)
					game.removeVisual(material)
				}
			} 
		}	
		
		D.onPressDo { 
			if(rick.posicion() == rick.companero().posicion()) {
				rick.companero().darObjetosA(rick)
			} 
		}
		
		E.onPressDo{game.say(rick, "" + rick.experimentosQuePuedeRealizar())}
		
		M.onPressDo {
					game.say(rick,"" + rick.mochila())
					game.say(morty,"" + morty.elementosDeLaMochila())
		}
		
		NUM_1.onPressDo{rick.realizar(construirBateria)}
		NUM_2.onPressDo{rick.realizar(construirCircuito)}
		NUM_3.onPressDo{rick.realizar(construirShockElectrico)}
		
		
		//	PARED
		const ancho = game.width() - 1
		const largo = game.height() - 1
	
		(1 .. ancho-1).forEach { n => new ParedAbajo(new Position(n, 1)) } // BordeAbajo
		(1 .. ancho-1).forEach { n => new ParedArriba(new Position(n, largo)) } // BordeArriba 
		(2 .. largo-1).forEach { n => new ParedIzquierda(new Position(1, n)) } // BordeIzq 
		(2 .. largo-1).forEach { n => new ParedDerecha(new Position(ancho-1, n)) } // BordeDer
		
		
		// MOCHILAS 
	
		(1 .. ancho-1).forEach { n => new OtraCelda(new Position(n, 0)) } // BordeAbajo
		(0 .. largo).forEach { n => new Celda(new Position(0, n)) } // BordeDer
		(0 .. largo).forEach { n => new Celda(new Position(ancho, n)) } // BordeIzq
	}
}