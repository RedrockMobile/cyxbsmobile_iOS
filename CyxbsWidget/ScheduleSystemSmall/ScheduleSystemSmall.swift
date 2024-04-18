//
//  ScheduleSystemSmall.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/4/16.
//  Copyright © 2024 Redrock. All rights reserved.
//

import SwiftUI

struct ScheduleSystemSmall: View {
    
    let mappy: RYScheduleMaping
    
    let date: Date
    
    let section: Int
    
    let weekDay: Int
    
    var courseModel: ScheduleCalModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .bottom, spacing: 5) {
                
                // 周次
                Text(ScheduleDataFetch.sectionString(withSection: section))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                
                //星期几
                Text(ScheduleDataFetch.weekString(with: weekDay - 1))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                
                Spacer()
                
            }
            
            Spacer()
            
            Divider()
                .padding(.bottom, 2)
            
            // 课程名称
            Text(courseModel?.curriculum.course ?? "没课啦")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                .lineLimit(2)
            
            Divider()
                .padding(.init(top: 6, leading: 0, bottom: 4, trailing: 0))
            
            HStack(alignment: .center, spacing: 5) {
                
                // 教室
                Text(courseModel?.curriculum.classRoom ?? "休息一下吧")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                    .lineLimit(2)
                
                //上课时间
                Text(formatTime(from: courseModel?.startCal) ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                    .lineLimit(2)
            }
            
            Divider()
                .padding(.top, 2)
            
            Spacer()
            
            HStack(alignment: .bottom, spacing: 5) {
                
                // 更新时间
                Text("更新于\(formatTime(from: date) ?? "")")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                    .lineLimit(1)
                
                Spacer()
                
            }
        }
    }
    
    init(mappy: RYScheduleMaping, section: Int, date: Date) {
        self.mappy = mappy
        self.date = date
        self.section = section
        self.weekDay = Calendar.current.component(.weekday, from: date)
        self.courseModel = calCourseWillBeTaking()
    }
    
    // 遍历当周课表，获取下一节要上的课
    private func calCourseWillBeTaking() -> ScheduleCalModel? {
        var cal: ScheduleCalModel? = nil
        for collection in mappy.datas[section] {
            if let startDate = collection.cal.startCal, let endDate = collection.cal.endCal {
                if Calendar.current.isDateInToday(startDate) {
                    if startDate <= date && date <= endDate {
                        return collection.cal
                    }
                    if date <= startDate {
                        guard let old = cal else {
                            cal = collection.cal
                            continue
                        }
                        if let calStart = old.start, startDate < calStart {
                            cal = collection.cal
                        }
                    }
                }
            }
        }
        return cal
    }
    
    // 将Date对象对应时间转换为"HH:mm"字符串
    private func formatTime(from date: Date?) -> String? {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"  // 设置日期格式为 "HH:mm" 表示24小时制的小时和分钟
            return dateFormatter.string(from: date)
        }
        return nil
    }
}


