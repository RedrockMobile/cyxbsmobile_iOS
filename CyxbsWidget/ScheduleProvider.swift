//
//  Provider.swift
//  CyxbsWidget
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import WidgetKit
import Intents
import SwiftDate

typealias ScheduleWidgetConfiguration = ConfigurationIntent

struct ScheduleProvider: IntentTimelineProvider {    
    
    // 定义更新的时间线(每次下课5分钟后更新，避免出错)
    let refreshTimes: [String] = ["6:00", "8:50", "9:45", "11:05", "12:00", "14:50", "15:45", "17:05", "18:00", "19:50", "20:45", "21:40"]
    
    func placeholder(in context: Context) -> ScheduleTimelineEntry {
        let entry = ScheduleTimelineEntry(date: Date())
        return entry
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        
        var entry = ScheduleTimelineEntry(date: Date(), configuration: configuration)
      
        if let model = CacheManager.shared.getCodable(ScheduleModel.self, in: .init(rootPath: .bundle, file: "sno2021215154.data")) {
            
            entry.models.append(model)
        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        
        guard let mainSno = UserModel.default.token?.stuNum else { return }
        
        ScheduleModel.request(sno: mainSno) { response in
            let currentDate = DateInRegion()
            let dateStringPrefix = currentDate.dateAtStartOf(.day).toFormat("yyyy-MM-dd")
            var entries: [ScheduleTimelineEntry] = []
            
            if let response {
                for timeString in refreshTimes {
                    if let entryDate = (dateStringPrefix + " " + timeString).toDate(region:.current)?.date {
                        var entry = ScheduleTimelineEntry(date: entryDate, configuration: configuration)
                        entry.models.append(response)
                        entries.append(entry)
                    }
                }
            } else {
                var entry = ScheduleTimelineEntry(date: currentDate.date, configuration: configuration)
                entry.errorMsg = "请求有问题"
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    
}

