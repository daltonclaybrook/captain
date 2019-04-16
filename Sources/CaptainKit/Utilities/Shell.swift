import Foundation

struct ShellResult {
    let status: Int32
    let standardOut: String
    let standardError: String
}

struct Shell {
    private let directory: String

    init(directory: String = FileManager.default.currentDirectoryPath) {
        self.directory = directory
    }

    func run(command: String) -> ShellResult {
        let echoPipe = Pipe()
        let outPipe = Pipe()
        let errorPipe = Pipe()

        let echoProcess = Process()
        echoProcess.currentDirectoryPath = directory
        echoProcess.launchPath = "/bin/echo"
        echoProcess.arguments = [command]
        echoProcess.standardOutput = echoPipe

        let bashProcess = Process()
        bashProcess.currentDirectoryPath = directory
        bashProcess.launchPath = "/bin/bash"
        bashProcess.standardInput = echoPipe
        bashProcess.standardOutput = outPipe
        bashProcess.standardError = errorPipe

        echoProcess.launch()
        bashProcess.launch()
        echoProcess.waitUntilExit()
        bashProcess.waitUntilExit()

        let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let outString = String(decoding: outData, as: UTF8.self)
        let errorString = String(decoding: errorData, as: UTF8.self)

        return ShellResult(status: bashProcess.terminationStatus, standardOut: outString, standardError: errorString)
    }
}
