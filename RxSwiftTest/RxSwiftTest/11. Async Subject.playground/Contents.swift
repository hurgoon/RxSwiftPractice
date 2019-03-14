import UIKit
import RxSwift

enum SomeError: Error {
    case unknown
}

func async() {
    
    let index = AsyncSubject<Int>() // completed가 필요하며, 마지막 밸류만 발행된다
                                    // 정정 : 컴플리트가 될 때(필수), 마지막 서브젝트만 구독 된다
    index.onNext(0)
    
    let bag = DisposeBag()
    
    index.subscribe { (event) in
        print("1)", event.element ?? event)
    }.disposed(by: bag)
    
    index.onNext(1)
    
    index.subscribe { (event) in
        print("2)", event.element ?? event)
    }.disposed(by: bag)
    
    index.onNext(2)
    index.onNext(3)
    index.onCompleted()
//    index.onError(SomeError.unknown) // onCompleted는 안됐지만 에러는 발행됨. // onCompleted 뒤에는 에러가 와도 발행 노.
    
    index.subscribe { (event) in
        print("3)", event.element ?? event)
    }.disposed(by: bag)

}
async()
