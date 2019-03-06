import UIKit
import RxSwift

// Disposing = canceling
func range() {
    let rangeObserver = Observable.range(start: 1, count: 4)
    
    let bag = DisposeBag()
    
    let subscription = rangeObserver.subscribe(
        onNext: { print($0) },
        onError: nil,
        onCompleted: { print("Range Completed") },
        onDisposed: { print("Range disposed") })
    
    //  subscription.dispose()
    
    subscription.disposed(by: bag)
}
range()

// Memory Leak
func memoryLeak() {
    
    enum NumError: Error {
        case InvalidNumber
    }
    
//    let bag = DisposeBag()
    
    Observable<Int>.create { (observer) -> Disposable in
        
        observer.onNext(1)
//        observer.onError(NumError.InvalidNumber)
        observer.onNext(2)
//        observer.onCompleted()
        observer.onNext(3)
        
        return Disposables.create()
        
    }.subscribe(
        onNext: { print($0) },
        onError: { print("Error", $0) },
        onCompleted: { print("observable compleated") },
        onDisposed: { print("Subscription disposed") })
    
//    .disposed(by: bag)  // -> observer.onCompleted와 .disposed를 하지 않으면 구독종료 되지 않으며, memory leak이 발생한다.
}
memoryLeak()

func never() {
    
    let neverObserver = Observable<Any>.never()
    
    let bag = DisposeBag()
    
    neverObserver.subscribe(
        onNext: { print($0) },
        onError: nil,
        onCompleted: { print("completed") },
        onDisposed: { print("Never subscription is disposed")}
    ).disposed(by: bag)
}
never()
