import UIKit
import RxSwift

var str = "Hello, playground"

struct Student {
    var score: BehaviorSubject<Int>
}

func flatMap() {
    let student1 = Student(score: BehaviorSubject<Int>(value: 70))
    let student2 = Student(score: BehaviorSubject<Int>(value: 80))
    let bag = DisposeBag()
    
    let subject = PublishSubject<Student>()
    
    //    subject.map({ $0.score }).map({ try $0.value() }).subscribe({ print($0) }).disposed(by: bag)

//    subject.map({ $0.score }).map({ $0.subscribe({ print($0) }).disposed(by: bag) }).subscribe({ print($0, "==Void") }).disposed(by: bag)
    
//    subject.map({ $0.score }).switchLatest().subscribe({ print($0) }).disposed(by: bag)
    
//        subject.flatMap({ $0.score }).subscribe({ print($0) }).disposed(by: bag) // flatMap으로 밸류까지 접근 가능
    
    subject.flatMapLatest({ $0.score }).subscribe({ print($0) }).disposed(by: bag)
    
    subject.onNext(student1)
    student1.score.onNext(90)
    
    subject.onNext(student2)
    student1.score.onNext(60)
    
    student2.score.onNext(100)
}
flatMap()

print(" ============= ")

// nil값 제거해 주는 방법
func unwrap() {
    let bag = DisposeBag()
    
    let observable = Observable.of(1, nil, 3, 4, 5, nil, nil)
    
    observable.filter({ $0 != nil }).map({ $0 ?? 0 }) .subscribe({ print($0) }).disposed(by: bag)
    
    // observable.unwrap().subscribe({ print($0) }).disposed(by: bag) // import RxSwiftExt설치시 사용가능
}
unwrap()
