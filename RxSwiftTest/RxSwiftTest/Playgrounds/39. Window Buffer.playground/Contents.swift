import UIKit
import RxSwift

extension DispatchSource {
    class func timer(interval : Double, queue: DispatchQueue, handler: @escaping () -> Void ) -> DispatchSourceTimer {
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: interval, leeway: .nanoseconds(0))
        timer.setEventHandler(handler: handler)
        timer.resume()
        
        return timer
    }
}

extension Int {
    var spellOut: String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: value) ?? "Nil"
    }
}

let elementPerSecond: Double = 3
let timeout: RxTimeInterval = 4
let capacity = 10
let subject = PublishSubject<String>()

_ = subject.subscribe({ print("Control", $0) })

var observableIndex = 0

_ = subject
    .window(timeSpan: timeout, count: capacity, scheduler: MainScheduler.instance)
    .do(onNext: { _ in print("Observable emmited") })
    .flatMap({ (windowObservable) -> Observable<(Int, String)> in
        
        observableIndex += 1
        
        return windowObservable.map({ (observableIndex, $0) })
    })
    .subscribe({ print("Window", $0) })

var count = 0

let timer = DispatchSource.timer(interval: 1/elementPerSecond, queue: .main) {
    count += 1
    subject.onNext(count.spellOut)
}
