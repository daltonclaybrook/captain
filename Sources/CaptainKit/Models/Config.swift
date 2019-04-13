public struct Config {
    public let hooks: [Hook]
    public let customHooks: [CustomHook]
}

public struct Hook {
    public let name: String
    public let parameters: [String: Any]
}

/// Structurally the same as `Hook`, but nominally different to
/// prevent incorrect usage in the `EvaluatorRegistry`
public struct CustomHook {
    public let name: String
    public let parameters: [String: Any]
}

extension Config {
    init(dict: [String: Any]) {
        let hookNames = dict["hooks"] as? [String] ?? []
        let customHookDicts = dict["custom_hooks"] as? [String: [String: Any]] ?? [:]
        self.hooks = hookNames.map { name in
            let parameters = dict[name] as? [String: Any] ?? [:]
            return Hook(name: name, parameters: parameters)
        }
        self.customHooks = customHookDicts.map(CustomHook.init)
    }
}
