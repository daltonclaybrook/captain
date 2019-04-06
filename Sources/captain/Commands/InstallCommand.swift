import CaptainKit
import Commandant
import Curry

struct InstallCommand: CommandProtocol {
    let verb = "install"
    let function = "Parse the .captain.yml file and install any necessary git hooks"

    func run(_ options: InstallOptions) -> Result<(), CaptainError> {
        print(options)
        // TODO: do the thing
        return .success(())
    }
}

struct InstallOptions: OptionsProtocol {
    let projectPath: String
    let configPath: String
    let clean: Bool
    let force: Bool

    static func evaluate(_ mode: CommandMode) -> Result<InstallOptions, CommandantError<CaptainError>> {
        return curry(self.init)
            <*> mode <| Argument(defaultValue: ".", usage: "Path to the project directory", usageParameter: "path")
            <*> mode <| Option(key: "config", defaultValue: ".captain.yml", usage: "Path to the config file")
            <*> mode <| Option(key: "clean", defaultValue: false, usage: "Clone all sources even if they are cached")
            <*> mode <| Option(key: "force", defaultValue: false,
                               usage: "Overwrite any existing git hooks that are not setup by Captain")
    }
}
