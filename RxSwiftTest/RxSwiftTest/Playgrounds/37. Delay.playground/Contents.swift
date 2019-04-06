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

let elementsPerSecond: Double = 1
let delay: TimeInterval = 1.5
let subject = PublishSubject<Int>()

_ = subject.subscribe({ print("Control: ", $0) })
_ = subject
//    .delaySubscription(RxTimeInterval(delay), scheduler: MainScheduler.instance)
    .delay(RxTimeInterval(delay), scheduler: MainScheduler.instance)
    .subscribe({ print("Delay Subscription", $0) })

var count = 0

let timer = DispatchSource.timer(interval: 1/elementsPerSecond, queue: .main) {
    subject.onNext(count)
    count += 1
}

