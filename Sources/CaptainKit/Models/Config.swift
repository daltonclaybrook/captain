public struct Config {
    public let hooks: [Hook]
}

public struct Hook {
    public let name: String
    public let parameters: [String: Any]
    public let custom: Bool
}

extension Config {
    init(dict: [String: Any]) {
        let hookNames = dict["hooks"] as? [String] ?? []
        let customHookDicts = dict["custom_hooks"] as? [String: [String: Any]] ?? [:]
        let systemHooks = hookNames.map { name -> Hook in
            let parameters = dict[name] as? [String: Any] ?? [:]
            return Hook(name: name, parameters: parameters, custom: false)
        }
        let customHooks = customHookDicts.map { name, parameters -> Hook in
            Hook(name: name, parameters: parameters, custom: true)
        }
        self.hooks = systemHooks + customHooks
    }
}
