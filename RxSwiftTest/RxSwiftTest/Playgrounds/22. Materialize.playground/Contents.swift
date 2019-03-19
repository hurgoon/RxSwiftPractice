import UIKit
import RxSwift

struct Student {
    var score: BehaviorSubject<Int>
}

enum StudentError: Error {
    case unknown
}

func materialize() {
    let student1 = Student(score: BehaviorSubject<Int>(value: 70))
    let student2 = Student(score: BehaviorSubject<Int>(value: 80))
    
    let subject = BehaviorSubject<Student>(value: student1)
    
    let bag = DisposeBag()
    
    let observable = subject.flatMap({ $0.score.materialize() }) // .materialize를 붙이면 inner 서브젝트만 에러를 받고, outer 서브젝트는 진행된다
//    observable.subscribe({ print($0) }).disposed(by: bag)
    
    let newObservable = observable.filter { (event) -> Bool in // 이벤트를 필터링 하는 건...가?..
        guard let error = event.error else { return true }
        
        print(error)
        
        return false
    }.dematerialize()
    
    newObservable.subscribe({ print($0) }).disposed(by: bag)
    
    student1.score.onError(StudentError.unknown)
    student1.score.onNext(90)
    subject.onNext(student2)
    student2.score.onNext(100)
}
materialize()
