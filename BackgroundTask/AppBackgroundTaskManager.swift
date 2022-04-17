//
//  AppBackgroundTaskManager.swift
//  BackgroundTask
//
//  Created by wanggang on 2021/9/25.
//

import Foundation
import UIKit
import AVFoundation

class AppBackgroundTaskManager: NSObject {
    var audioPlayer: AVAudioPlayer!
    var audioEngine = AVAudioEngine()
    var bgTask: UIBackgroundTaskIdentifier!
    var app = UIApplication.shared
    var applyTimer: Timer?
    var taskTimer: Timer?
    
    
    static let shared = AppBackgroundTaskManager.init()
    
    
    func startBackgroundTask(app: UIApplication) {
        self.bgTask = app.beginBackgroundTask {
            self.app.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            self.applyForMoreTime()
        }
        applyTimer?.invalidate()
        applyTimer = nil
//        applyTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(applyForMoreTime), userInfo: nil, repeats: true)
        taskTimer?.invalidate()
        taskTimer = nil
        taskTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(doSomething), userInfo: nil, repeats: true)
    }
    
    func stopBackgroundTask() -> () {
        applyTimer?.invalidate()
        applyTimer = nil
        taskTimer?.invalidate()
        taskTimer = nil
    }
    
    @objc func applyForMoreTime() -> () {
        if app.backgroundTimeRemaining < 30 {
            self.bgTask = app.beginBackgroundTask(expirationHandler: {
                self.app.endBackgroundTask(self.bgTask)
                self.bgTask = UIBackgroundTaskIdentifier.invalid
                self.applyForMoreTime()
            })
            let path = Bundle.main.path(forResource: "Silence", ofType: "wav")!
            let filePathUrl = NSURL.init(fileURLWithPath: path)

            do {
                try AVAudioSession.sharedInstance()
                    .setCategory(.playback,
                                 mode: .default,
                                 policy: .default,
                                 options: .mixWithOthers)
            } catch  {

            }
            self.audioPlayer = try? AVAudioPlayer(contentsOf: filePathUrl as URL)
            self.audioEngine.reset()
            self.audioPlayer.play()

//            if let task = self.bgTask {
//                self.app.endBackgroundTask(task)
//            }

            self.audioPlayer.stop()
        }
    }
    @objc func doSomething() {
        print("doing some thing:\(UIApplication.shared.backgroundTimeRemaining)")
    }
    
}
