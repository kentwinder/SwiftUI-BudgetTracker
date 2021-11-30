//
//  BudgetTracker_Widget.swift
//  BudgetTracker Widget
//
//  Created by Kent Winder on 2/8/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), amount: Int(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), amount: Int(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let repository = BudgetRepository()
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            var amount: Int = 0
            do {
                amount = try repository.getTotalAmount()
            } catch {
            }
            let entry = SimpleEntry(date: entryDate, amount: amount, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let amount: Int
    let configuration: ConfigurationIntent
}

struct BudgetTracker_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.amount)").font(.headline)
    }
}

@main
struct BudgetTracker_Widget: Widget {
    let kind: String = "BudgetTracker_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BudgetTracker_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Budget Tracker Widget")
        .description("Budget Tracker Widget")
    }
}

struct BudgetTracker_Widget_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTracker_WidgetEntryView(entry: SimpleEntry(date: Date(), amount: 1234, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
