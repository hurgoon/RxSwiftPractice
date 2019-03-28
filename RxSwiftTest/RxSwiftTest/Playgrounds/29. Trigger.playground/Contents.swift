import UIKit
import RxSwift

func withLatestFrom() {
    let nameTextField = PublishSubject<String>()
    let updateButton = PublishSubject<Void>()
    let bag = DisposeBag()
    
    updateButton.withLatestFrom(nameTextField).subscribe({ print($0) }).disposed(by: bag)
    
    nameTextField.onNext("Apoo")
    nameTextField.onNext("Apoor")
    updateButton.onNext(()) // 마지막 값을 방출한다(그 전은 무시)
    nameTextField.onNext("Apoorv")
    updateButton.onNext(())
    updateButton.onNext(())
}
withLatestFrom()

print("==========")

func sample() {
    let nameTextField = PublishSubject<String>()
    let updateButton = PublishSubject<Void>()
    let bag = DisposeBag()
    
    nameTextField.sample(updateButton).subscribe({ print($0 )}).disposed(by: bag)
    nameTextField.onNext("Appo")
    nameTextField.onNext("Apooooor")
    updateButton.onNext(()) // 야는 벨류가 바뀌고나서 트리거를 눌러야 바뀐다. 벨류가 바뀌지 않으면 트리거 아무리 눌러도 소용없음
    updateButton.onNext(())
    nameTextField.onNext("Apoooooooooooorv")
    updateButton.onNext(())
}
sample()
