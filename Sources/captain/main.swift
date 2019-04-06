import CaptainKit
import Commandant
import Foundation

let registry = CommandRegistry<CaptainError>()
registry.register(InitCommand())
registry.register(HelpCommand(registry: registry))

let install = InstallCommand()
registry.register(install)

registry.main(defaultVerb: install.verb) { error in
    fputs(error.description + "\n", stderr)
}
