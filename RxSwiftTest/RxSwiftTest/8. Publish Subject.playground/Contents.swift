import UIKit
import RxSwift

func subject() {
    
    let publish = PublishSubject<Int>()  // 구독시점부터 서브젝트 구독. 이전 서브젝트는 무시.
    
    publish.on(.next(1)) // 퍼블리쉬 만으로는 실행 반응 없음. "구독자" 있어야함
    
    let subscriber = publish.subscribe{ (event) in // 후에 발행한 퍼블리쉬도 받아 온다
        print("1번구독", event.element ?? event)
    }
    
    publish.onNext(2) // publish.on(.next(1))과 같은 방법
    
    let bag = DisposeBag()
    
    publish.subscribe{ (event) in // 이전 발행한 퍼블리쉬는 받아 올 수 없다
        print("2번구독", event.element ?? event)
    }.disposed(by: bag)
    
    publish.onNext(3)
    
    subscriber.dispose() // -> 이 지점에서 subscriber(1번구독)가 디스포즈 됨
    
    publish.onNext(4)
    
    publish.onCompleted() // -> 이 시점에서 publish는 모두 구독 중지 됨.(6이 구독되지 않음)
    
    publish.subscribe{ (event) in // 이 역시 이전 발행한 퍼블리쉬는 받아 올 수 없다
        print("3번구독", event.element ?? event)
    }.disposed(by: bag)
    
    publish.onNext(6)
}

subject()
