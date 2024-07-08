//
//  CyxbsWidgetLiveActivityManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/7/8.
//  Copyright © 2024 Redrock. All rights reserved.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
@available(iOSApplicationExtension 16.1, *)
class CyxbsWidgetLiveActivityManager: NSObject {
    
    static let shared = CyxbsWidgetLiveActivityManager()
    
    private var activity: Activity<CyxbsWidgetAttributes>? = nil
    
    
    /// 创建LiveActivity(正常情况下只在AppDelegate里调一次)
    @available(iOS 16.2, *)
    func create() {
        if activity == nil {
            let attributes = CyxbsWidgetAttributes(name: "iOS 新知")
            let state = CyxbsWidgetAttributes.ContentState(date: Date(), section: 1, weekdat: 1, course: "1", classRoom: "1", startCal: Date())
            let content = ActivityContent<CyxbsWidgetAttributes.ContentState>(state: state, staleDate: nil)
            do {
                activity = try Activity<CyxbsWidgetAttributes>.request(attributes: attributes, content: content)
            } catch let error {
                print("出错了：\(error.localizedDescription)")
            }
        }
    }
    
    /// 更新LiveActivity内容
    @available(iOS 16.1, *)
    func update(contentState:CyxbsWidgetAttributes.ContentState) {
        Task {
            await activity?.update(using: contentState)
        }
    }
    
    @available(iOS 16.1, *)
    func update() {
        
    }
    
    /// 停止LiveActivity
    @available(iOS 16.1, *)
    func end() {
        Task {
            await activity?.end()
            activity = nil
        }
    }
}
