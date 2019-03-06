import UIKit
import RxSwift

// Side Effects

func sideEffects() {
    
    let rangeObserver = Observable.range(start: 1, count: 4)
    
    let bag = DisposeBag()
    
//    rangeObserver.do(
//        onNext: { print("Will next", $0) },
//        onError: nil,
//        onCompleted: { print("Will complete Range") },
//        onSubscribe: { print("Will subscribe") },
//        onSubscribed: { print("Did subscribe") },
//        onDispose: { print("Did dispose subscription") }
//    ).subscribe(
//        onNext: { print($0) },
//        onError: nil,
//        onCompleted: { print("Range completed")},
//        onDisposed: { print("Subscription Disposed") }
//    ).disposed(by: bag)
    
    rangeObserver.debug("Range Debug", trimOutput: true    // 디버그를 사용해서 스트림을 확인 할 수 있다
    ).subscribe(
        onNext: { print($0) },
        onError: nil,
        onCompleted: { print("Range Completed") },
        onDisposed: { print("Subscription disposed") }
    ).disposed(by: bag)
}

sideEffects()
