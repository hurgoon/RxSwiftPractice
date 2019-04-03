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
let totalElements = 5
let bufferSize = 1
let delay: TimeInterval = 3
let sourceObservable = Observable<Int>.create { (observer) -> Disposable in
    var count = 1
    let timer = DispatchSource.timer(interval: 1/elementsPerSecond, queue: .main, handler: {
        if count <= totalElements {
            observer.onNext(count)
            count += 1
        }
    })
    return Disposables.create {
        timer.suspend()
    }
}.replay(bufferSize)
_ = sourceObservable.subscribe( { print("Control", $0) })
DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
    _ = sourceObservable.subscribe({ print("Delay", $0) })
}

_ = sourceObservable.connect()


