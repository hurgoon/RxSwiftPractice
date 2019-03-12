import UIKit
import RxSwift
import RxCocoa

enum SomeError: Error {
    case unknown
}

//func behaviorWrapper() {
//
//    let relay = BehaviorRelay(value: 0) // 구독없이 value에 접근할 수 있다
//    print("Current value", relay.value)
//
//    relay.accept(1)
//    print("Current value2", relay.value)
//
//    let bag = DisposeBag()
//
//    relay.subscribe { (event) in
//        print("1)", event.element ?? event)
//    }.disposed(by: bag)
//
//    relay.accept(2)
//    print("Current value3", relay.value)
//
//    relay.accept(SomeError.unknown)
//    relay.asObservable().onError(SomeError.unknown)
//    relay.accept(onCompleted())
//    relay.asObservable().onCompleted()
//}
//behaviorWrapper()

func publishWrapper() {
    
    let relay = PublishRelay<Int>()
    relay.accept(0)
    
    let bag = DisposeBag()
    
    relay.subscribe { (event) in
        print("1)", event.element ?? event)
    }.disposed(by: bag)
    
    relay.accept(1)
}
publishWrapper()

