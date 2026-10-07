import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let overdueCount: Int
    let dueTodayCount: Int
    let overdueNames: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            overdueCount: 2,
            dueTodayCount: 1,
            overdueNames: ["Canon Camera", "Projector"]
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        completion(readEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let entry = readEntry()

        let nextRefresh = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: Date()
        )!

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextRefresh)
        )

        completion(timeline)
    }

    private func readEntry() -> SimpleEntry {
        let defaults = UserDefaults(
            suiteName: "group.com.zhenyu.CampusEquipment"
        )

        let overdueCount = defaults?.integer(
            forKey: "overdueCount"
        ) ?? 0

        let dueTodayCount = defaults?.integer(
            forKey: "dueTodayCount"
        ) ?? 0

        let overdueNames = defaults?.stringArray(
            forKey: "overdueNames"
        ) ?? []

        return SimpleEntry(
            date: Date(),
            overdueCount: overdueCount,
            dueTodayCount: dueTodayCount,
            overdueNames: overdueNames
        )
    }
}

struct CampusEquipmentWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Campus Equipment")
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("\(entry.overdueCount)")
                        .font(.title2)
                        .bold()

                    Text("Overdue")
                        .font(.caption)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("\(entry.dueTodayCount)")
                        .font(.title2)
                        .bold()

                    Text("Due Today")
                        .font(.caption)
                }
            }

            if !entry.overdueNames.isEmpty {
                Divider()

                ForEach(entry.overdueNames.prefix(2), id: \.self) { name in
                    Text(name)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct CampusEquipmentWidget: Widget {
    let kind: String = "CampusEquipmentWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            if #available(iOS 17.0, *) {
                CampusEquipmentWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CampusEquipmentWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Campus Equipment")
        .description("Shows overdue and due-today equipment.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

#Preview(as: .systemSmall) {
    CampusEquipmentWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        overdueCount: 2,
        dueTodayCount: 1,
        overdueNames: ["Canon Camera", "Projector"]
    )
}

#Preview(as: .systemMedium) {
    CampusEquipmentWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        overdueCount: 2,
        dueTodayCount: 1,
        overdueNames: ["Canon Camera", "Projector"]
    )
}
