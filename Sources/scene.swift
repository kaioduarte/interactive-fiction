import Foundation
import SwiftyJSON

class Scene {
    var name: String
    var description: String
    var commands: [Command]
    
    init(name: String, description: String, commands: [Command]){
        self.name = name
        self.description = description
        self.commands = commands
    }
}