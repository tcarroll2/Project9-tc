//
//  ViewController.swift
//  Project9-tc
//
//  Created by Thomas Carroll on 4/23/20.
//  Copyright © 2020 Thomas Carroll. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // runBackgroundCode4()
        // runSynchronousCode()
        // runMultiprocessing1()
        runMultiprocessing2(useGCD: false)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc func log(message: String) {
        print("Printing message: \(message)")
    }

    func runBackgroundCode1() {
        performSelector(inBackground: #selector(log), with: "Hello world 1")
        performSelector(onMainThread: #selector(log), with: "Hello world 2", waitUntilDone: false)
        log(message: "Hello world 3")
    }

    func runBackgroundCode2() {
        DispatchQueue.global().async {
            [unowned self] in self.log(message: "On background thread")
            DispatchQueue.main.async {
                self.log(message: "On main thread")
            }
        }
    }
    
    func runBackgroundCode3() {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://www.apple.com") else { return }
            guard let str = try? String(contentsOf: url) else { return }
            print(str)
        }
    }
    
    func runBackgroundCode4() {
        DispatchQueue.global(qos: .userInteractive).async {
            [unowned self] in self.log(message: "This is high priority")
        }
    }
    
    func runSynchronousCode() {
        // asynchronous!
        DispatchQueue.global().async {
            print("Background thread 1")
        }
        print("Main thread 1")
        // synchronous!
        DispatchQueue.global().sync {
            print("Background thread 2")
        }
        print("Main thread 2")
    }
    
    func runMultiprocessing1() {
        DispatchQueue.concurrentPerform(iterations: 10) {
            print($0)
        }
    }
    
    func runMultiprocessing2(useGCD: Bool) {
        func fibonacci(of num: Int) -> Int {
            if num < 2 {
                return num
            } else {
                return fibonacci(of: num - 1) + fibonacci(of: num - 2)
            }
        }
        var array = Array(0 ..< 42)
        let start = CFAbsoluteTimeGetCurrent()
        if useGCD {
            DispatchQueue.concurrentPerform(iterations: array.count) {
                array[$0] = fibonacci(of: $0)
            }
        }
        let end = CFAbsoluteTimeGetCurrent() - start
        print("Took \(end) seconds")
    }

}

