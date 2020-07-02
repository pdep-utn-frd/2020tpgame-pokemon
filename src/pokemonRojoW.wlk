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
			// Detener movimiento de Habilidades
			// keyboard.p().onPressDo {game.removeTick("movimientoHidrocanion")}
			// Poderes
		keyboard.space().onPressDo({ blastoise.ataque()})
		keyboard.enter().onPressDo({ charizard.ataque()})
			// Colisiones
		game.whenCollideDo(blastoise, { habilidad => blastoise.puedoColisionar(habilidad)})
		game.whenCollideDo(charizard, { habilidad => charizard.puedoColisionar(habilidad)})
		game.whenCollideDo(charizard, { pokemon => charizard.colisionConPokemon(pokemon)})
		game.whenCollideDo(blastoise, { pokemon => blastoise.colisionConPokemon(pokemon)})
		
		//game.whenCollideDo(hidrocanion, { llamarada =>habilidad.colision(h)})
	}

}

object blastoise {

	var property position = game.at(1, 3)
	var property vidas = 8

	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 100)
	}

	method image() = "blastoise.png"

	method ataque() {
		const hidrocanion = new Habilidad(nombre = "Hidrocanion", danio = 150, position = self.position(), imagen = "hidrocañon.png")
		game.say(self, hidrocanion.nombre())
		game.addVisual(hidrocanion)
		hidrocanion.movete1(self)
		game.onTick(3000, "movimientoHidrocanion", { hidrocanion.movete1(self)})
	// keyboard.p().onPressDo ({game.removeTickEvent("movimientoHidrocanion")})
	}

	method colisionoCon(llamarada) {
		if (vidas < 0) {
			game.say(charizard, "Murio Blastoise")
			game.removeVisual(self)
			game.removeVisual(llamarada)
		} else {
			self.restarVida(llamarada)
			game.say(self, " mi vida actual : " + self.vidas())
			game.removeVisual(llamarada)
		}
	}

	method puedoColisionar(habilidad) {
		var auxi = habilidad.nombre()
		if (auxi == "Llamarada") {
			self.colisionoCon(habilidad)
		} else {
		}
	}

	method colisionConPokemon(pokemon) {
		self.position().x() - 1
		self.position().y()
	}

}

object charizard {

	var property position = game.at(10, 3)
	var property vidas = 12

	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 100)
	}

	method image() = "charizard2.png"

	method ataque() {
		const llamarada = new Habilidad(nombre = "Llamarada", danio = 110, position = self.position(), imagen = "llamarada.png")
		game.say(self, llamarada.nombre())
		game.addVisual(llamarada)
		llamarada.movete2(self)
		game.onTick(3000, "movimientoLlamarada", { llamarada.movete2(self)})
	}

	method colisionoCon(hidrocanion) {
		if (vidas < 0) {
			game.say(blastoise, "Murio Blastoise")
			game.removeVisual(self)
			game.removeVisual(hidrocanion)
		} else {
			self.restarVida(hidrocanion)
			game.say(self, " mi vida actual : " + self.vidas())
			game.removeVisual(hidrocanion)
		}
	}

	method puedoColisionar(habilidad) {
		var auxi = habilidad.nombre()
		if (auxi == "Hidrocanion") {
			self.colisionoCon(habilidad)
		} else {
		}
	}

	method colisionConPokemon(pokemon) {
		self.position().x() + 1
		self.position().y()
	}

}

class Habilidad {

	var property nombre
	var property danio
	var property position
	var imagen

	method image() = imagen

	method explosion(habilidad) {
		game.removeVisual(habilidad)
		game.addVisual("Explosion.png")
	}

	method colision(habilidad) {
		self.explosion(habilidad)
		
	}

	method movete1(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}

	method movete2(pokemon) {
		const x = pokemon.position().x() - 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}

}

class Explosiones {

	var imagen

	method image() = imagen

//	method colision(habilidad) {
//		self.explosion(habilidad)
//		
//	}
}

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
