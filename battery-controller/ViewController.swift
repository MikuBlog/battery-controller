//
//  ViewController.swift
//  battery-controller
//
//  Created by 旋仔 on 2023/4/28.
//

import Cocoa
import IOKit.ps

class ViewController: NSViewController {
    
    @IBOutlet weak var inputNumber: NSTextField!
    
    @IBOutlet weak var rangeSelector: NSSlider!
    
    
    // 定时任务
    var timer: Timer? = nil

    // 获取电池信息
    func getCurrentBatteryLevel() -> Int {
        // 获取电池信息
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as [CFTypeRef]

        // 获取第一个电池的电量信息
        if let battery = sources.first {
            let description = IOPSGetPowerSourceDescription(snapshot, battery).takeUnretainedValue() as! [String: Any]
            let capacity = description[kIOPSCurrentCapacityKey] as? Int
            let maxCapacity = description[kIOPSMaxCapacityKey] as? Int
            let percentage = Double(capacity ?? 0) / Double(maxCapacity ?? 100)
            return Int(percentage * 100)
        }
        // 默认返回100电量（可能压根没有电池）
        return 100
    }
    
    
    
    // 启动定时器
    func startTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            // 当前电池电量
            let batteryQuality = self.getCurrentBatteryLevel()
            // 如果电池电量等于输入框的值，停止充电，开始使用充电器
            if (batteryQuality == Int(self.inputNumber.stringValue)) {
                
            }
        }
    }
    
    // 关闭定时器
    func stopTimer() {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSelector.action = #selector(sliderValueChanged(_:))
        inputNumber.action = #selector(inputNumberChanged(_:))
//        startTimer()
//        print(getCurrentBatteryLevel())
        // Do any additional setup after loading the view.
    }
    
    // 监听rangeSelector值的变化
    @objc func sliderValueChanged(_ sender: NSSlider) {
        // 处理 slider 值变化
//        print("slider 值变为：\(sender.doubleValue)")
        inputNumber.stringValue = sender.stringValue
    }
    
    // 监听inputNumber值的变化
    @objc func inputNumberChanged(_ sender: NSTextField) {
        
        var value = Int(sender.stringValue)!
        
        if value > 100 {
            value = 100
        }
        if value < 0 {
            value = 0
        }
        
        inputNumber.stringValue = String(value)
        
        print(value)
        // 处理 slider 值变化
//        print("slider 值变为：\(sender.doubleValue)")
        rangeSelector.stringValue = String(value)
    }
    
    // 放电
    @IBAction func discharge(_ sender: Any) {
        // 当前电池电量
        let batteryQuality = self.getCurrentBatteryLevel()
        print(batteryQuality)
    }
    
    // 充电
    @IBAction func charge(_ sender: Any) {
        // 当前电池电量
        let batteryQuality = self.getCurrentBatteryLevel()
        print(batteryQuality)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

