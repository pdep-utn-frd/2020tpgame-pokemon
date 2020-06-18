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
	
	method image() = "BlastoisePixel.png"
	
	
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
		game.say(self, "Blastoise uso Hidro Cañon")
	}
	
}

object charizard {
	
	var property position = game.at(10,3)
	
	method image() = "CharizardPixel.png"
	
	
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
		game.say(self, "Charizard uso Llamarada")
		
	}
	
}

object llamarada{
	
	var property position 
	
	method image() = "llamarada.png"

	method moverAlInfinito(pokemon) {
		position = pokemon.position().left(1)
	}
	
}

object hidrocanion{

	var property position
	
	method image() = "hidrocañon.png"

	method moverAlInfinito(pokemon) {
		position = pokemon.position().right(1)
	}
	
}