//
//  SubjectInPracticeViewController.swift
//  RxSwiftTest
//
//  Created by Bernard Hur on 13/03/2019.
//  Copyright © 2019 Bernard Hur. All rights reserved.
//

import UIKit
import RxSwift

class SubjectInPracticeViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var openButton: UIButton!
    
    var timer: Timer!
    var progress:Float = 0
    var subject = PublishSubject<Float>()
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0

        progressLabel.text = "0%"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInvoked), userInfo: nil, repeats: true)
        
        subject.subscribe(onNext: { (num) in
            self.progressView.progress = num
            self.progressLabel.text = String(format: "%d%%", Int(num * 100))
        }, onError: { (error) in // 구독중 에러 발생시 알럿 삽입
            print(error)
            self.showAlert(with: "Failed!!", message: error.localizedDescription).subscribe().disposed(by: self.bag)
        }, onCompleted: {
            self.progressView.isHidden = true
            self.progressLabel.isHidden = true
            self.openButton.isHidden = false
        }, onDisposed: nil).disposed(by: bag)
    }
    
    enum SomeError: Error { case unknown }
    
    @objc func timerInvoked() {
        
        progress += 0.2
        
        subject.onNext(progress)
        
        if progress == 1 {
            subject.onCompleted()
            timer.invalidate()
        } else if progress == 0.6 {  // 인위적 에러 삽입
            subject.onError(SomeError.unknown)
            timer.invalidate()
        }
    }
}

extension UIViewController {
    
    func showAlert(with title: String, message: String) -> Completable {
        
        return Completable.create(subscribe: { [weak self] (completable) -> Disposable in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss!", style: .default, handler: { (_) in
                completable(.completed)
            }))
            
            self?.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
            
        })
    }
}
