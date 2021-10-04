//
//  AppDelegate.swift
//  BackgroundTask
//
//  Created by wanggang on 2021/9/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var taskTimer: Timer?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 调用申请后台保活
        AppBackgroundTaskManager.shared.startToApplyTimeForBackgroundTask()
        
        // 测试代码，打印看一下后台保活或者模拟后台干一些其他事情。
        // 说明: 后台保活就是上面的AppBackgroundTaskManager.shared.startApplyBackgroundTask()
        // 而在后台干事情，不一定非要这个位置写代码。可以在项目的任何位置，如在某个页面发起一些网络请求。
        doSomethingInBackground()
    }
    
    func doSomethingInBackground() {
        // 后台做一些事情
        taskTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            print("doing some thing:\(UIApplication.shared.backgroundTimeRemaining)")
        }
    }
    
    func stopDoingSomethingInBackgroud() -> () {
        taskTimer?.invalidate()
        taskTimer = nil
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        stopDoingSomethingInBackgroud()
    }


}

