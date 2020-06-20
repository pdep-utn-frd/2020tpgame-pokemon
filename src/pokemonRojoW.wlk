import wollok.game.*

object juego {
	
	method inicio(){
		
		//movimiento
		
		keyboard.a().onPressDo({blastoise.moverL()})
		keyboard.s().onPressDo({blastoise.moverDown()})
		keyboard.d().onPressDo({blastoise.moverR()})
		keyboard.w().onPressDo({blastoise.moverUp()})
		keyboard.j().onPressDo({charizard.moverL()})
		keyboard.k().onPressDo({charizard.moverDown()})
		keyboard.l().onPressDo({charizard.moverR()})
		keyboard.i().onPressDo({charizard.moverUp()})
		
		//poderes
		
		keyboard.space().onPressDo({blastoise.hidroCanion()})
		keyboard.space().onPressDo({llamarada.moverAlInfinito(charizard)})
		
		keyboard.enter().onPressDo({charizard.llamarada()})
		keyboard.enter().onPressDo({hidrocanion.moverAlInfinito(blastoise)})
		
	}
}

object blastoise {
	
	var property position = game.at(1,3)
	
	method image() = "blastoise.png"
	
	
	method moverL(){
		position = position.left(1)
	}
	method moverDown(){
		position = position.down(1)
	}
	method moverR(){
		position = position.right(1)
	}
	method moverUp(){
		position = position.up(1)
	}
	
	method hidroCanion(){
		const hidrocanion = new Habilidad (nombre = "Hidro Cañon",
										   danio = 150,
										   position = self.position(),
										   imagen= "hidrocañon.png"
										   )
		
		game.say(self,{hidrocanion =>  "Blastoise uso" hidrocanion.nombre()})
	}
	
}

object charizard {
	
	var property position = game.at(10,3)
	
	method image() = "charizard2.png"
	
	
	method moverL(){
		position = position.left(1)
	}
	method moverDown(){
		position = position.down(1)
	}
	method moverR(){
		position = position.right(1)
	}
	method moverUp(){
		position = position.up(1)
	}
	
	method llamarada(){
		const Llamarada = new Habilidad (nombre = "Llamarada",
										   danio = 110,
										   position = self.position(),
										   imagen= "llamarada.png"
										   )
		game.say(self,{Llamarada =>  "Charizard uso" Llamarada.nombre()})
		
	}
	
}

class Habilidad { 
	
	var property nombre
	var danio
	var property position
	var imagen 
	
	method image() = imagen 
	
	method cuantoDanio(){
		return danio
	}

}

//Hacer una clase poder o ataque

// pokemon tiene variable vidas 10, un method restarvida(ataque)
// vida = vida - habilidad.daño()

// un method actualizar vista quita al pokemon muerto

//para el ataque paso posicion y pokemon que lo usa

// limitar movimiento de posiciones hasta limite de pantalla

//calcular el limite y donde estoy para, que la hablilidad sepa hasta
//donde se puede mover el ataque















