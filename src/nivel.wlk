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
		
		//Al presionar la tecla R, el compañero de Rick recoge todos los materiales que este en
		//la misma posicion.
		R.onPressDo { 
			materialesBasicos.forEach { material => 
				if(rick.companero().posicion() == material.posicion()) {
					rick.companero().recolectar(material)
					game.removeVisual(material)
				}
			} 
		}	
		
		//Al presionar la tecla D, el compañero de Rick les da los objetos que tiene en la mochila
		//si esta en la misma posicion.
		D.onPressDo { 
			if(rick.posicion() == rick.companero().posicion()) {
				rick.companero().darObjetosA(rick)
			} 
		}
		
		//Al presionar la tecla E, Rick dice que experimentos que puede realizar con los materiales
		//que posee en su poder.
		E.onPressDo{game.say(rick, "" + rick.experimentosQuePuedeRealizar())}
		
		//Al presionar la tecla M, Rick dice que elementos contiene en su mochila. A su vez, el
		//compañero de Rick dice que materiales tiene en su mochila tambien.   
		M.onPressDo {
					game.say(rick,"" + rick.mochila())
					game.say(rick.companero(),"" + rick.companero().elementosDeLaMochila())
		}
		
		//Al presionar la tecla del numero 1, Rick tratara de construir una bateria.
		NUM_1.onPressDo{rick.realizar(construirBateria)}
		
		//Al presionar la tecla del numero 2, Rick tratara de construir un circuito.
		NUM_2.onPressDo{rick.realizar(construirCircuito)}
		
		//Al presionar la tecla del numero 3, Rick tratara de contruir un shock electrico.
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