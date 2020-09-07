import wollok.game.*

const blastoise = new PokemonTipoAgua(position = game.at(1, 3), vidas = 8,nombre = "blastoise",desplazamiento = 1, imagen = "blastoise.png",tipo = "agua")

const charizard = new PokemonTipoFuego(position = game.at(10, 3), vidas = 12,nombre = "charizard",desplazamiento = -1, imagen = "charizard2.png",tipo = "fuego")

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
			// Poderes
		keyboard.space().onPressDo({ blastoise.ataque()})
		keyboard.enter().onPressDo({ charizard.ataque()})
			// Colisiones
		game.whenCollideDo(blastoise, { objeto => blastoise.colisionar(objeto)})
		game.whenCollideDo(charizard, { objeto => charizard.colisionar(objeto)})
            // Musica
		const musicaPokemon = game.sound("Musica.mp3")
		game.schedule(100, { musicaPokemon.play()})
		musicaPokemon.volume(0.5)
				
	}
	
	//method reiniciar(){}
	//dos teclas, 1 para volver a empezar otra  y 1 para salir
	
}

	// poner variable para el desplazamiento

class Pokemon {

	var property position 
	var property vidas
	var property nombre
	var property desplazamiento
	var imagen
	
	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 100)
	}
	
	method sosPokemon(){return true}
	method sosUnAtaque(){return false}
	
	 // no usar sosPokemon ni sosAqtaque, usar self

	method image() = imagen


	method colisionoConPokemon(otroPokemon) {
		if(otroPokemon.desplazamiento()== 1) {game.onCollideDo(self, {movimiento => movimiento.moveteDerecha(self)})}
		else {game.onCollideDo(self, {movimiento => movimiento.moveteIzquierda(self)})}
	}

	method colisionar(objeto) {
		if (//FILTRAR POKEMON ){
			self.colisionoConPokemon(objeto)
		}
		if (//FILTRAR ATAQUE) {
			self.colisionoConAtaque(objeto)
		} else {
		}
	}

	method colisionoConAtaque(objeto) {
		self.restarVida(objeto)
		if (self.vidas() <= 0) {
			// game.say(charizard, "Murio Blastoise")
			const ganador = game.sound("Winner.mp3")
			ganador.play()
			game.removeVisual(self)
			game.removeVisual(objeto)
		} else {
			game.say(self, " mi vida actual : " + self.vidas().toString().toString())
			game.removeVisual(objeto)
		}
	}

 	//method colisionarCon(objeto){
 	  //const colision = new Colisiones(pokemon = self)
 	  //colision.colisionar(objeto)
 //}
//	method colisionPokemon(pokemon) {
//		const colision = new Colisiones(pokemon = self)
//		colision.colisionar(self, pokemon)
//	}

//	method colisionAtaque(habilidad) {
//		const colision = new Colisiones()
//		colision.colisionar(habilidad, self)
//	}


}

class PokemonTipoAgua inherits Pokemon{
	var property tipo

	method miAtaque(){
			  const hidrocanion = new AtaqueAgua(nombre = "Hidrocanion", danio = 150, position = blastoise.position(), imagen = "hidrocañon.png")
			  return hidrocanion
	}

	method ataque() {
		const ataqueAgua = self.miAtaque()
		game.say(self, ataqueAgua.nombre())
		game.addVisual(ataqueAgua) 
		ataqueAgua.movete1(self)
		game.whenCollideDo(ataqueAgua, { ataque2 => ataqueAgua.colision(ataque2, ataqueAgua)})
		game.onTick(500, "movimientoAtaque", { ataqueAgua.moverAtaque(self)})
	}
}

class PokemonTipoFuego inherits Pokemon{
	var property tipo

	method miAtaque(){
			  const llamarada = new AtaqueFuego(nombre = "Llamarada", danio = 110, position = charizard.position(), imagen = "llamarada.png")
			  return llamarada
	}

	method ataque() {
		const ataqueFuego = self.miAtaque()
		game.say(self, ataqueFuego.nombre())
		game.addVisual(ataqueFuego) 
		ataqueFuego.movete2(self)
		game.whenCollideDo(ataqueFuego, { ataque2 => ataqueFuego.colision(ataque2, ataqueFuego)})
		game.onTick(500, "movimientoAtaque", { ataqueFuego.moverAtaque(self)})
	}
}

// colisiones no sirve , que los pokemones y ataques se arreglen solos

class Habilidad {

	var property nombre
	var property danio
	var property position
	var imagen

	method sosPokemon(){return false}
	method sosUnAtaque(){return true}

	method image() = imagen

	method colision(habilidad1, habilidad2) {
		const explosion1 = new Explosion()
		explosion1.position(habilidad1.position())
		game.addVisual(explosion1)
		game.removeVisual(habilidad2)
		game.removeVisual(habilidad1)
		game.schedule(300, {=> game.removeVisual(explosion1)})
	}

	method moverAtaque(pokemon) {
		var direccion = 0
		if (pokemon.tipo() == "agua") {
			direccion = 1
		} else {
			direccion = -1
		}
		const x = self.position().x() + direccion
		const y = self.position().y()
		position = game.at(x, y)
	}

}

class AtaqueAgua inherits Habilidad{

	method movete1(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}
}

class AtaqueFuego inherits Habilidad {

	method movete2(pokemon) {
		const x = pokemon.position().x() - 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}
}


class Explosion {

	var property position = game.center()

	method image() = "Explosion.png"

}

// hay que usar objeto movimiento par mover los ataques y pokemon

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

