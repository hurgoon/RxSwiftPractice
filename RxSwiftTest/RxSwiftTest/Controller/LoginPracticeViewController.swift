//
//  LoginPracticeViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 14/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginPracticeViewController: UIViewController {
    var bag = DisposeBag()
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false) // 외부 변수 생성하고 내부펑션안의 결과 값을 bind해줄수 있다
    let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        bindUI()
        bindUI2()
    }
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idValidView: UIView!
    @IBOutlet weak var pwValidView: UIView!
    
    private func bindUI() {
        idField.rx.text.orEmpty
//            .filter { $0 != nil } 언랩핑 이 두줄을 "orEmpty"로 대체 가능
//            .map { $0! }
            .map(checkEmailValid)
            .subscribe(onNext: { [weak self] bool in  // 텍스트필드의 입력을 대기하고 있기 때문에 메모리 해제가 안되나(레퍼런스 카운트가 증가된 상태로 유지), [weak self]로 해결함.  혹은!! viewWillDisappear에서 bag = Disposebag() 으로 초기화 시켜줘도 됨
                self?.idValidView.isHidden = bool })
            .disposed(by: bag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { bool in
                self.pwValidView.isHidden = bool })
            .disposed(by: bag)
        
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1, s2 in s1 && s2 }
        )
            .subscribe(onNext: { bool in self.loginButton.isEnabled = bool })
            .disposed(by: bag)
    }
    
    private func bindUI2() { // 고급 기술이라 하시만, 상기와 크게 다르지는 않음. 옵져버블 변수화 및 활용에 밑줄 쫙!
        
        let idInputOb: Observable<String> = idField.rx.text.orEmpty.asObservable()
        idInputOb.bind(to: idInputText).disposed(by: bag) // 아이디 입력값을 외부변수에 바인딩 해줌
                                                          // 바인딩 한 외부변수를 그대로 펑션 내부에서 쓸 수 있다
        let idValidOb: Observable<Bool> = idInputOb.map(checkEmailValid)
        idValidOb.bind(to: idValid).disposed(by: bag) // 스트림 결과 값을 외부 변수에 바인딩(인풋) 해줌
        
        let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
        let pwValidOb: Observable<Bool> = pwInputOb.map(checkPasswordValid)
        pwValidOb.bind(to: pwValid).disposed(by: bag) // 스트림 결과 값을 외부 변수에 바인딩(인풋) 해줌
        
        idValidOb.subscribe(onNext: { bool in self.idValidView.isHidden = bool }).disposed(by: bag)
        pwValidOb.subscribe(onNext: { bool in self.pwValidView.isHidden = bool }).disposed(by: bag)
        
        Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1 })
            .subscribe(onNext: { bool in self.loginButton.isEnabled = bool }).disposed(by: bag)
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}
