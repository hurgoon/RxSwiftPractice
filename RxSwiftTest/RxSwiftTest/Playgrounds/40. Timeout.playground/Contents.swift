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

let elementsPerSecond: Double = 0.7
let totalElements = 5
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
}

//_ = sourceObservable   // 조건(totalElements)에 맞쳐지면 에러 방출함
//    .timeout(3, scheduler: MainScheduler.instance)
//    .subscribe({ print($0) })

_ = sourceObservable   // 조건(totalElements)에 맞쳐지면 에러 방출하지 않고 다음 섭스크라이브 진행
    .timeout(3, other: Observable.just(777), scheduler: MainScheduler.instance)
    .subscribe({ print($0) })
