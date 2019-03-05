import UIKit
import RxSwift

let justObservable = Observable.just(5) // "just"는 Int 하나만 가능
let doubleObservable: Observable<Double> = Observable<Double>.just(5)
let ofObservable = Observable.of(1)
let multiObservable = Observable.of(1, 2, 3, 4)
let arrayObservable = Observable.of([1, 2], [3, 4])
let fromObservable = Observable.from([1, 2, 3, 4])


// subscribe, Event
let multiObserver = Observable.of(1, 2, 3, 4)

multiObserver.subscribe { (event) in
    print(event.element ?? event)  // 기본은 옵셔널. event.element가 nil이면 event(complete)가 출력됨
}

// Subscribe, onNext, onComplete
multiObserver.subscribe(onNext: { (element) in
    print(element)
}, onError: nil, onCompleted: { print("Muti is Completed")}, onDisposed: nil) // complete시 액션 지정 가능

// rangeObserver
let rangeObserver = Observable<Int64>.range(start: 1, count: 4)  // Type지정 예

rangeObserver.subscribe(
    onNext: { print($0) },
    onError: nil,
    onCompleted: { print("Range Completed") },
    onDisposed: nil)

// emptyObserver : 바로 complete를 실행할 때 사용됨
let emptyObserver = Observable<Void>.empty()

emptyObserver.subscribe(
    onNext: { print($0) },
    onError: nil,
    onCompleted: { print("Empty finished")},
    onDisposed: nil)

// neverObserver : infinite 경우에 사용됨. 안끝남.
let neverObserver = Observable<Any>.never()

neverObserver.subscribe(
    onNext: { print($0) },
    onError: nil,
    onCompleted: { print("Completed") }, // completed 출력되지 않음
    onDisposed: nil)

// Factory
var toggle = false

let factory = Observable.deferred { () -> Observable<Int> in  // Observable<Int>를 리턴 해야한다
    toggle = !toggle
    return toggle ? Observable.of(11, 22, 33) : Observable.of(333, 444, 555)
}

for _ in 0...3 {
    factory.subscribe { (event) in
        print(event.element ?? event)
    }
}
