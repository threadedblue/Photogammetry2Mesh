import Foundation
import RealityKit
import Combine

final class Session {
    
    let inputFolder = URL(fileURLWithPath: "/Users/myUser/myPictures", isDirectory: true)
    let outputFile = URL(fileURLWithPath: "/Users/myUser/result.usdz")
    var subscriber: AnyCancellable?
    let semaphore = DispatchSemaphore(value: 0)
    
    func run() throws {
        let configuration = PhotogrammetrySession.Configuration()
        let session = try PhotogrammetrySession(
            input: inputFolder,
            configuration: configuration
        )
        let request = PhotogrammetrySession.Request.modelFile(url: outputFile)
        
        let waiter = Task.init {
            do {
                for try await output in session.outputs {
                    switch output {
                    case .processingComplete:
                        print("")
                    case .requestError(let request, let error):
                        print("", request, error)
                    case .requestComplete(let request, let result):
                        print("", request, result)
                    case .requestProgress(let request, let fractionComplete):
                        print("", request, fractionComplete)
                    case .inputComplete:
                        print("")
                    case .invalidSample(let id, let reason):
                        print("", id, reason)
                    case .skippedSample(let id):
                        print("", id)
                    case .automaticDownsampling:
                        print("")
                    case .processingCancelled:
                        print("")
                    @unknown default:
                        print("")
                    }
                }
            } catch {
                print("Output: ERROR = \(String(describing: error))")
                // Handle error.
            }
        }
    }
}

try! Session().run()
