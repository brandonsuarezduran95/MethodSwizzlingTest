//
//  ViewController.swift
//  MethodSwizzlingTest
//
//  Created by Brandon Suarez on 2/17/24.
//

import UIKit

class ViewController: UIViewController {
    
    let label = UILabel()
    let testSwizzling = TestSwizzling()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Method Swizzling"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        setupLabel()
        
        print("First Method:",testSwizzling.firstMethod(), "Second Method:" ,testSwizzling.secondMethod())
        testSwizzling.swizzling()
        print("First Method:",testSwizzling.firstMethod(), "Second Method:" ,testSwizzling.secondMethod())
    }
    
    override func perform() {
        print("Override perform")
    }
    
    
    func setupLabel() {
        view.addSubview(label)
        label.numberOfLines = 0
        label.text = "Method swizzling is the process of changing the implementation of an existing selector at runtime. Simply speaking, we can change the functionality of a method at runtime.This is possible with the power of objective C runtime.\nCheck the debug area"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 17),
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -17)
        ])
    }

}

extension UIViewController {
    
    @objc func perform() {
        print("Performed")
    }
}

class TestSwizzling: NSObject {
    
    @objc dynamic func firstMethod() -> Int {
        return 20
    }
    
    @objc dynamic func secondMethod() -> Int {
        return 60
    }
    
    func swizzling() {
        let firstSelector = #selector(TestSwizzling.firstMethod)
        let secondSelector = #selector(TestSwizzling.secondMethod)
        
        guard
            let originalMethod = class_getInstanceMethod(TestSwizzling.self, firstSelector),
            let swizzlingMethod = class_getInstanceMethod(TestSwizzling.self, secondSelector)
        else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzlingMethod)
    }
    
}

//extension TestSwizzling {
//    func swizzling() {
//        guard
//            let originalMethod = class_getInstanceMethod(TestSwizzling.self, #selector(TestSwizzling.firstMethod)),
//            let swizzlingMethod = class_getInstanceMethod(TestSwizzling.self, #selector(TestSwizzling.secondMethod))
//        else {
//            return
//        }
//        
//        method_exchangeImplementations(originalMethod, swizzlingMethod)
//    }
//    
//    @objc func secondMethod() -> Int {
//        return 60
//    }
//}
