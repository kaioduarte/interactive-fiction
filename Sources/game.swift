import Foundation
import SwiftyJSON


class Game {
	var file: FileHandle?
	var data: Data
	var json: JSON
	var scenes: [Scene] = []
	var current_scene: Scene?


	init(){
		self.file = FileHandle(forReadingAtPath: "/home/kds/bot/Sources/scene.json")
		self.data = self.file!.readDataToEndOfFile()
		self.json = JSON(data: data)
		self.scenes = getScenes()
		self.current_scene = self.scenes[0]
	}


	func restart() {
		self.current_scene = self.scenes[0]
	}


	func getScenes() -> [Scene] {
	    var scenes: [Scene] = []
	    
	    for (_, js) : (String, JSON) in self.json {
			var commands: [Command] = []

			for (_, iAux) : (String, JSON) in js["commands"] {
				commands.append(Command(
					text: iAux["text"].string!,
					key: iAux["key"].string!
				))
			}

	        scenes.append(Scene(
        		name: js["name"].string!,
        		description: js["description"].string!,
    			commands: commands
	        ))
	    }

	    return scenes
	}


	func validateCommand(text: String) -> Scene? {
	    for command in self.current_scene!.commands {
	        if command.text == text {
	            return getNextScene(name: command.key)
	        }
	    }
	    
	    return nil
	}


	func getNextScene(name: String) -> Scene? {
		for scene in self.scenes {
			if scene.name == name {
				return scene
			}
		}

		return nil
	}
}