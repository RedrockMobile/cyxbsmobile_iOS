//
//  CyxbsWidgetLiveActivity.swift
//  CyxbsWidget
//
//  Created by SSR on 2023/9/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.1, *)
struct CyxbsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var date: Date
        var section: Int
        var weekdat: Int
        var course: String
        var classRoom: String
        var startCal: Date
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

@available(iOS 16.1, *)
struct CyxbsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CyxbsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello ")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("14:00")
            } compactTrailing: {
                Text("3501")
            } minimal: {
                Text("")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

@available(iOS 16.1, *)
extension CyxbsWidgetAttributes {
    fileprivate static var preview: CyxbsWidgetAttributes {
        CyxbsWidgetAttributes(name: "World")
    }
}

//@available(iOS 16.1, *)
//extension CyxbsWidgetAttributes.ContentState {
//    fileprivate static var smiley: CyxbsWidgetAttributes.ContentState {
//        CyxbsWidgetAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: CyxbsWidgetAttributes.ContentState {
//         CyxbsWidgetAttributes.ContentState(emoji: "🤩")
//     }
//}
