//
//  CameleonView.swift
//  rxSwiftExam
//
//  Created by Sung Min Park on 2021/04/22.
//

import Foundation
import UIKit

//import ChameleonFramework
import RxCocoa
import RxSwift

class CameleonView: UIViewController {
    var circleView: UIView!
    var vm: CameleonViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = CameleonViewModel()
        setLayout()
    }
    
    func setLayout() {
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 50.0, height: 50.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .magenta
        view.addSubview(circleView)
        
        let gestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(onMovedCircleView(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
        
        circleView.rx.observe(CGPoint.self, "center")
            .bind(to: vm.centerVariable)
            .disposed(by: disposeBag)
        
        vm.backgorundColorObservable
            .subscribe (onNext:{ [unowned self](backgroundColor) in
                self.circleView.backgroundColor = backgroundColor
//                let viewComplementaryColor = UIColor(complementaryFlatColorOf: backgroundColor)
//                if viewComplementaryColor != backgroundColor {
//                    self.view.backgroundColor = viewComplementaryColor
//                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func onMovedCircleView(_ recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}

class CameleonViewModel {
    var centerVariable = BehaviorRelay<CGPoint?>(value: .zero)
    var backgorundColorObservable: Observable<UIColor>!
    
    init() {
        setup()
    }
    
    func setup() {
        backgorundColorObservable = centerVariable.asObservable().map({ (center) -> UIColor in
            guard let center = center else { return UIColor.black }
            
            let red:CGFloat = CGFloat((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
            let green:CGFloat = 0.0
            let blue:CGFloat = 0.0
//            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
            return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        })
    }
}
