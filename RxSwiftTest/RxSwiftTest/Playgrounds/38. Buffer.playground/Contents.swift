import UIKit
import RxSwift

let timeout: RxTimeInterval = 4
let capacity = 2
let subject = PublishSubject<Int>()

_ = subject.subscribe({ print("Control :", $0) })

_ = subject
    .buffer(timeSpan: timeout, count: capacity, scheduler: MainScheduler.instance)
    .map({ $0.count })
    .subscribe({ print("Buffer Count :", $0) })

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    Array(1...3).forEach({ subject.onNext($0) })
}
