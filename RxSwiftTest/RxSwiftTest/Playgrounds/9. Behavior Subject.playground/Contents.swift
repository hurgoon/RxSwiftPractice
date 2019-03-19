import UIKit
import RxSwift

enum FatchedError: Error {
    case failed
}

func behaviorSubject() { // BehaviorSubject - 초기구독시 Subject가 설정한 초기값을 가져오고, 그 뒤는 onNext 값을 가져옴.
                         // 후발 구독시 최신 OnNext값을(초기값 말고) 이어서 가져온다.
                         // 중간에 에러가 발생하면, 그 뒤의 구독은 실패한다
    let subject = BehaviorSubject(value: "Loading...")
    let bag = DisposeBag()
    
    subject.subscribe { (event) in
        print("1)", event.element ?? event)
    }.disposed(by: bag)
    
    subject.onNext("Fatched Value")
    subject.subscribe { (event) in
        print("2)", event.element ?? event)
    }.disposed(by: bag)
    
//    subject.onError(FatchedError.failed)
    subject.onNext("New Value")
    subject.subscribe { (event) in
        print("3)", event.element ?? event)
    }.disposed(by: bag)
}

behaviorSubject()
