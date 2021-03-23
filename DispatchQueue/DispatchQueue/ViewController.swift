//
//  ViewController.swift
//  DispatchQueue
//
//  Created by gaobing on 2021/3/19.
//

/*
  任务只有两种，同步任务和异步任务，无论同步任务是处在什么队列中，它都会让当前正在执行的线程等待它执行完成

 Serial 串行队列
 Concurrent 并发队列

 */

import UIKit

class ViewController: UIViewController {
    fileprivate func syncQueue() {
        let queue = DispatchQueue(label: "Serial.Queue")

        print("thread: \(Thread.current)")

        queue.sync {
            (0 ..< 5).forEach { print("rool-1 -> \($0): \(Thread.current)") }
        }

        queue.sync {
            (0 ..< 5).forEach { print("rool-1 -> \($0): \(Thread.current)") }
        }
    }

    fileprivate func asyncSerial() {
        let queue = DispatchQueue(label: "serial.com")
        print("thread:\(queue)")
        for i in 0 ... 5 {
            print("main-\(i)")
            // 让线程休眠0.2s，目的是为了模拟耗时操作
            Thread.sleep(forTimeInterval: 0.2)
        }
        queue.async {
            (0 ..< 5).forEach {
                print("rool-1 -> \($0): \(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        queue.async {
            (0 ..< 5).forEach {
                print("rool-2 -> \($0): \(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
    }

    fileprivate func serialQueue2() {
        let queue = DispatchQueue(label: "serial.com")
        print("1: \(Thread.current)")
        queue.async {
            print("2: \(Thread.current)")
        }
        print("3: \(Thread.current)")
        queue.async {
            print("4: \(Thread.current)")
        }
        print("5: \(Thread.current)")
    }

    fileprivate func asyncQueue3() {
        print("main-1")
        // 串行或并发队列
        let queue = DispatchQueue(label: "serial.com")
        queue.async {
            (0 ..< 20).forEach {
                print("async \($0)")
            }
        }
        // 开辟线程的时间大约是90微妙，加上循环的准备以及打印时间，
        // 这里给它200微妙，测试async任务中的线程和当前线程之间的执行顺序。
        //        Thread.sleep(forTimeInterval: 0.0002000)

        // 不会等待！线程不会等待 async 执行完成就会执行打印 main-2 的操作
        print("main-2")
    }

    fileprivate func mainQueue() {
        print("1")
        DispatchQueue.main.async {
            (0 ..< 10).forEach {
                print("async\($0) \(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        print("3")
    }

    fileprivate func initiallyInactiveQueue() {
        let queue = DispatchQueue(label: "serial.com", attributes: .concurrent)
        queue.sync {
            (0 ..< 10).forEach {
                print("task-1 \($0): \(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        print("main-1")
        queue.sync {
            (0 ..< 10).forEach {
                print("task-2 \($0): \(Thread.current)")
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        print("main-2")
    }

    fileprivate func concurrentQueue() {
        let queue = DispatchQueue(label: "concurrent.com", attributes: .concurrent)
        queue.sync {
            print("sync-start")
            queue.sync {
                (0 ..< 5).forEach {
                    print("task \($0): \(Thread.current)")
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
            print("sync-end")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建一个队列（默认就是串行队列，不需要额外指定参数）
        // syncQueue()

        // 示例2 - 在串行队列中执行异步 ( async ) 任务
        // asyncSerial()

        // 示例3 - 在串行队列中执行异步 ( async ) 任务 II
        // serialQueue2()

        // 示例4 - 异步任务，不管它处在什么队列中，当前线程都不会等待它执行完成
        // serialQueue3()

        //  UI 线程。
        // mainQueue()

        // concurrent 并发队列
        //        initiallyInactiveQueue()
        // 并发进程 串行
        concurrentQueue()

    }
}
