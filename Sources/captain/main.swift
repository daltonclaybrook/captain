import CaptainKit
import Commandant

let registry = CommandRegistry<CommandantError<()>>()
registry.register(InitCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    fputs(error.description + "\n", stderr)
}
