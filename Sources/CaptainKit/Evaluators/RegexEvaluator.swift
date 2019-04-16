import Foundation

enum RegexEvaluatorError: Error {
    case gitProcessFailed
    case invalidRegex(String)
    case matchesFound(files: [String])
}

/// TODO: Handle included/excluded files/folders
struct RegexEvaluator {
    let repoPath: String
    let regex: String

    func evaluate() -> Result<(), RegexEvaluatorError> {
        guard let expression = try? NSRegularExpression(
            pattern: regex, options: [.anchorsMatchLines, .dotMatchesLineSeparators]) else {
            return .failure(.invalidRegex(regex))
        }

        let shell = Shell(directory: repoPath)
        let fileNamesDiff = shell.run(command: "git diff --cached --name-only")
        guard fileNamesDiff.status == 0 else {
            return .failure(.gitProcessFailed)
        }

        let fileNames = fileNamesDiff.standardOut
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !$0.hasSuffix(".captain.yml") }
        var matchedFiles: [String] = []
        for file in fileNames {
            let fileDiff = shell.run(command: "git diff --cached \(file)")
            guard fileDiff.status == 0 else {
                return .failure(.gitProcessFailed)
            }
            let newLines = fileDiff.standardOut
                .components(separatedBy: "\n")
                .filter { $0.hasPrefix("+") }
                .map { $0[$0.index(after: $0.startIndex)...] }
                .joined(separator: "\n")

            let matches = expression.numberOfMatches(in: newLines, options: [], range: newLines.fullNSRange)
            if matches > 0 {
                matchedFiles.append(file)
            }
        }

        if !matchedFiles.isEmpty {
            return .failure(.matchesFound(files: matchedFiles))
        } else {
            return .success(())
        }
    }
}
