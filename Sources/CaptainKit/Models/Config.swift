import Foundation

public struct Config: Codable {
    public let hooks: [String]?
    public let customHooks: [String: CustomHook]?
}

public struct CustomHook: Codable {
    public let gitHook: String
    public let message: String
    public let regex: String
}

extension Config {
    public enum CodingKeys: String, CodingKey {
        case hooks
        case customHooks = "custom_hooks"
    }
}

extension CustomHook {
    public enum CodingKeys: String, CodingKey {
        case gitHook = "git_hook"
        case message
        case regex
    }
}
