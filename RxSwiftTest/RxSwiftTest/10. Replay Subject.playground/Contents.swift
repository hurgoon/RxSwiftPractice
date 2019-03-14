import UIKit
import RxSwift

enum SearchError: Error {
    case unknown
}


func replay() {
    
    let subject = ReplaySubject<String>.create(bufferSize: 2) // 처음 한번은 모든 구독 발행
    
    subject.onNext("YouTube")
    
    let bag = DisposeBag()
    
    subject.subscribe { (event) in
        print("1)", event.element ?? event)
    }.disposed(by: bag)
    
    subject.onNext("Netflix")
    
    subject.onNext("Prime Video")
    
    subject.subscribe { (event) in  // 두번째 구독부터 "버퍼 사이즈(역순)"만 발행. 버퍼 사이즈가 없으면 처음부터 다 구독
        print("2)", event.element ?? event)
    }.disposed(by: bag)
    
//    subject.onCompleted()
    
    subject.onError(SearchError.unknown)
    
    subject.dispose() // 디스포즈를 먼저 했기 때문에 그후에는 구독하지 않는다
    
    subject.onNext("IMDB")
    
    subject.subscribe { (event) in
        print("3)", event.element ?? event)
    }.disposed(by: bag  )
}
replay()
