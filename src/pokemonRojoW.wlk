import wollok.game.*

object juego {

	method inicio() {
		
		// Movimiento de Pj
		keyboard.a().onPressDo({ movimiento.moveteIzquierda(blastoise)})
		keyboard.d().onPressDo({ movimiento.moveteDerecha(blastoise)})
		keyboard.w().onPressDo({ movimiento.moveteArriba(blastoise)})
		keyboard.s().onPressDo({ movimiento.moveteAbajo(blastoise)})
		
		keyboard.j().onPressDo({ movimiento.moveteIzquierda(charizard)})
		keyboard.k().onPressDo({ movimiento.moveteAbajo(charizard)})
		keyboard.l().onPressDo({ movimiento.moveteDerecha(charizard)})
		keyboard.i().onPressDo({ movimiento.moveteArriba(charizard)})
		
		//Detener movimiento de Habilidades
		//keyboard.p().onPressDo {game.removeTick("movimientoHidrocanion")}
		
			// Poderes
		keyboard.space().onPressDo({ blastoise.ataque()})
		
		keyboard.enter().onPressDo({ charizard.ataque()})
			
			// Colisiones
		//game.whenCollideDo(blastoise, { habilidad => blastoise.colisionoCon(habilidad)
										//game.onTick(2000, "movimiento", habilidad.movete())
										//})
		
		//game.whenCollideDo(charizard, { habilidad => charizard.colisionoCon(habilidad)})
//		
//		game.whenCollideDo(habilidad, { habilidad2 =>habilidad.explosion(habilidad2)
//			const explosion = new Explosiones(imagen = "Explosion.png")
//			game.onTick(2000, "explosion", game.removeVisual(explosion))
//		})
	}

}

object blastoise {

	var property position = game.at(1, 3)
	var property vidas = 8
	
	method muerto() {
		return vidas == 0
	}

	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 10)
	}

	method image() = "blastoise.png"

	method ataque() {
		const hidrocanion = new Habilidad(nombre="Hidrocanion",danio = 150,position =self.position(),imagen = "hidrocañon.png")
		
		game.say(self, hidrocanion.nombre())
		game.onTick(300, "movimientoHidrocanion", {hidrocanion.movete()})
		game.addVisual(hidrocanion)
	}
}
//	method colisionoCon(habilidad) {
//		game.say(self, " mi vida actual : " + self.vidas())
//		game.removeVisual(habilidad)
//	}



object charizard {

	var property position = game.at(10, 3)
	var property vidas = 12

	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 10)
	}

	method muerto() {
		return vidas == 0
	}

	method image() = "charizard2.png"

	method ataque() {
		const llamarada = new Habilidad(nombre = "Llamarada", danio = 110,
			                            position = self.position(),
			                            imagen = "llamarada.png"
		)
		game.say(self, llamarada.nombre())
		game.onTick(300, "movimientoLlamarada", {llamarada.movete()})
		game.addVisual(llamarada)
	}

//	method colisionoCon(habilidad) {
//		game.say(self, " mi vida actual : " + self.vidas())
//		game.removeVisual(habilidad)
//	}

}

class Habilidad {

	var property nombre
	var property danio
	var property position
	var imagen

	method image() = imagen

	method explosion(habilidad) {
		game.removeVisual(habilidad)
	}
	method movete() {
		const x = (0.. game.width()-1).anyOne() 
		const y = (0.. game.height()-1).anyOne()
		position = game.at(x,y) 
	}
	

}

class Explosiones {

	var imagen

	method image() = imagen

}

//class ActualizarVista {
//
//	method quitarPokemonMuerto() {
//		if (pokemon.muerto()) {
//			game.removeVisual(pokemon)
//		}
//	}
//
//}

object movimiento {

	method moverL(objeto) {
		objeto.position(objeto.position().left(1))
	}

	method moverDown(objeto) {
		objeto.position(objeto.position().down(1))
	}

	method moverR(objeto) {
		objeto.position(objeto.position().right(1))
	}

	method moverUp(objeto) {
		objeto.position(objeto.position().up(1))
	}

	method moveteIzquierda(objeto) {
		if (objeto.position().x() > 0 and objeto.position().x() <= 11) self.moverL(objeto)
	}

	method moveteDerecha(objeto) {
		if (objeto.position().x() >= 0 and objeto.position().x() < 11) self.moverR(objeto)
	}

	method moveteArriba(objeto) {
		if (objeto.position().y() >= 0 and objeto.position().y() < 5) self.moverUp(objeto)
	}

	method moveteAbajo(objeto) {
		if (objeto.position().y() > 0 and objeto.position().y() <= 6) self.moverDown(objeto)
	}

}

// pokemon tiene variable vidas 10, un method restarvida(ataque)
// vida = vida - habilidad.daño()
// un method actualizar vista quita al pokemon muerto
//para el ataque paso posicion y pokemon que lo usa
// limitar movimiento de posiciones hasta limite de pantalla
//calcular el limite y donde estoy para, que la hablilidad sepa hasta
//donde se puede mover el ataque
