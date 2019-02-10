import Foundation

private enum LocalConstants {
    static let seconds = 1
}

protocol RealtimeTimerType {
    func startTimer(callback: @escaping () -> (Void))
    func stopTimer()
}

final class RealtimeTimer: RealtimeTimerType {
    private let timer = DispatchSource.makeTimerSource()

    func startTimer(callback: @escaping () -> (Void)) {
        timer.schedule(deadline: .now(), repeating: .seconds(LocalConstants.seconds))
        timer.setEventHandler {
            callback()
        }
        timer.resume()
    }
    
    func stopTimer() {
        timer.cancel()
    }
}
