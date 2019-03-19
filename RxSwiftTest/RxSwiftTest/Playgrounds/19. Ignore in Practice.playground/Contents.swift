import UIKit
import RxSwift

func phoneNumberFormatter() {
    let bag = DisposeBag()
    let subject = PublishSubject<Int>()
    
    subject.skipWhile({ $0 == 0}).filter({ $0 < 10 }).take(10).toArray().subscribe { (event) in
        guard let element = event.element else { print(event); return }
        print(element.map({ String($0) }).joined())
    }.disposed(by: bag)
    
    subject.onNext(0)
    subject.onNext(14)
    subject.onNext(8)
    subject.onNext(0)
    
    "0555888823498234928".forEach { (num) in
        guard let number = Int(String(num)) else { return }
        
        subject.onNext(number)
    }
    
}
phoneNumberFormatter()
