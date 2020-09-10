import wollok.game.*

const blastoise = new PokemonTipoAgua(position = game.at(1, 3), vidas = 100,vidaMax = 100,nombre = "blastoise",desplazamiento = "i", imagen = "blastoise.png",tipo = "agua")

const charizard = new PokemonTipoFuego(position = game.at(10, 3), vidas = 150,vidaMax = 150,nombre = "charizard",desplazamiento = "d", imagen = "charizard2.png",tipo = "fuego")

const mega = new PiedraMega(position = game.at(5,3))

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
		
	method reiniciar(){
		
	}
	
	method terminar(){
		
	}
	
}
	
	//method reiniciar(){}
	//dos teclas, 1 para volver a empezar otra  y 1 para salir
	


	// poner variable para el desplazamiento

class Pokemon {

	var property position 
	var property vidas
	var vidaMax
	var property nombre
	var property desplazamiento
	var property codigo = 1
	var imagen
	
	method restarVida(habilidad) {
		vidas = vidas - (habilidad.danio() / 10)
	}
	
	method restaurarSalud(habilidad){
		if (vidas <= vidaMax){
			vidas = vidas + vidas*habilidad.restaurarS() 
			}
		else {}
	}
	
	 // no usar sosPokemon ni sosAqtaque, usar self

	method image() = imagen
	
	method colisionoConPokemon() {
        game.onCollideDo(self, {otroPokemon => self.mover(otroPokemon)})
    }

	method mover(otroPokemon){
    	if(otroPokemon.desplazamiento()== "i"){
       	 movimiento.moveteIzquierda(otroPokemon)
       	 movimiento.moveteDerecha(self)
    	}
    	else {
    		movimiento.moveteDerecha(otroPokemon)
    		movimiento.moveteIzquierda(self)
    	}
	}
	
//	{game.onCollideDo(self, {movimiento => movimiento.moveteIzquierda(self)})}

	method colisionar(objeto){
		if(objeto.codigo() == 1){
			self.colisionoConPokemon()
			}
		if(objeto.codigo() == 0){
			self.colisionoConAtaque(objeto)
			}
		else {}
	}

	method colisionoConAtaque(objeto) {
		self.restarVida(objeto)
		if (self.vidas() <= 0) {
			//game.say(self, "IM WINNER")
			const ganador = game.sound("Winner.mp3")
			ganador.play()
			game.removeVisual(self)
			game.removeVisual(objeto)
		} else {
			game.say(self, " mi vida actual : " + self.vidas().toString().toString())
			game.removeVisual(objeto)
		}
	}
	
	method megaEvolucion(){
		// pasan cosas
		game.schedule(15000, {=> self.quitarMega()})
	}
	
	method quitarMega(){
		//quitar las bonificaciones de mega
	}

}

class PokemonTipoAgua inherits Pokemon{
	
	var property tipo
	var cargaAtqMax = 0

	method miAtaque(){
		if (cargaAtqMax <= 2){
			  const hidrocanion = new AtaqueAgua(nombre = "Hidrocanion", danio = 70, position = self.position(), imagen = "hidrocañon.png",bonificacionAtaque = 0)
			  cargaAtqMax = cargaAtqMax + 1
			  return hidrocanion
			  }
		else {
			const hidrocanionMaximo = new AtaqueAgua(nombre ="Hidrocanion Maximo",danio = 100, position = self.position(),imagen ="BolaDeAgua.png",bonificacionAtaque = 3)
			cargaAtqMax = 0
			return hidrocanionMaximo
		}
	}

	method ataque() {
		const ataqueAgua = self.miAtaque()
		self.restaurarSalud(ataqueAgua)
		game.say(self, ataqueAgua.nombre())
		game.addVisual(ataqueAgua) 
		ataqueAgua.movete1(self)
		game.whenCollideDo(ataqueAgua, { ataque2 => ataqueAgua.colision(ataque2, ataqueAgua)})
		game.onTick(500, "movimientoAtaque", { ataqueAgua.moverAtaque(self)})
	}
	
	override method megaEvolucion(){
		// pasan cosas para tipo Agua
		game.schedule(15000, {=> self.quitarMega()})
	}
	
}

class PokemonTipoFuego inherits Pokemon{
	
	var property tipo
	var cargaAtqMax = 0

	method miAtaque(){
		if (cargaAtqMax <= 3){
			  const llamarada = new AtaqueFuego(nombre = "Llamarada", danio = 40, position = self.position(), imagen = "llamarada.png",bonificacionSalud = 0)
			  cargaAtqMax = cargaAtqMax + 1
			  return llamarada
			  }
		else {
			const llamaradaMaxima = new AtaqueFuego(nombre ="Llamarada Maxima",danio = 110, position = self.position(),imagen ="BolaDeFuego.png",bonificacionSalud = 10)
			cargaAtqMax = 0
			return llamaradaMaxima
		}
	}

	method ataque() {
		const ataqueFuego = self.miAtaque()
		self.restaurarSalud(ataqueFuego)
		game.say(self, ataqueFuego.nombre())
		game.addVisual(ataqueFuego) 
		ataqueFuego.movete2(self)
		game.whenCollideDo(ataqueFuego, { ataque2 => ataqueFuego.colision(ataque2, ataqueFuego)})
		game.onTick(500, "movimientoAtaque", { ataqueFuego.moverAtaque(self)})
	}
	
	override method megaEvolucion(){
		// pasan cosas para tipo Fuego
		game.schedule(15000, {=> self.quitarMega()})
	}
}

class Habilidad {

	var property nombre
	var danio
	var property position
	var property codigo = 0
	var imagen

	method image() = imagen
	
	method danio(){
		return danio
	}
	
	method restaurarS(){
		return 0.05
	}
	
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
	
	var bonificacionAtaque
	
	override method danio(){
		return danio + ((bonificacionAtaque*danio)/6)
	}
	
	method movete1(pokemon) {
		const x = pokemon.position().x() + 1
		const y = pokemon.position().y()
		position = game.at(x, y)
	}
}

class AtaqueFuego inherits Habilidad {
	
	var bonificacionSalud
	
	override method restaurarS(){
		return bonificacionSalud/100
	}

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

class PiedraMega {
	
	var property position = game.center()
	
	method image()= "PiedraMega.png"
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

