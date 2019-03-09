import UIKit
import RxSwift

enum FatchedError: Error {
    case failed
}

func behaviorSubject() { // BehaviorSubject - 구독하면 Subject 에 의해 반환한 가장 최근 값을 가져오고, 구독 이후에 반환하는 값을 가져옵니다.
    let subject = BehaviorSubject(value: "Loading...")
    let bag = DisposeBag()
    
    subject.subscribe { (event) in
        print("1)", event.element ?? event)
    }.disposed(by: bag)
    
    subject.onNext("Fatched Value")
    subject.subscribe { (event) in
        print("2)", event.element ?? event)
    }.disposed(by: bag)
    
    subject.onError(FatchedError.failed)
    subject.onNext("New Value")
    subject.subscribe { (event) in
        print("3)", event.element ?? event)
    }.disposed(by: bag)
}

behaviorSubject()
