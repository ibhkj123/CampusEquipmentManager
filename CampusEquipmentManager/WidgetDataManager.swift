import Foundation
import WidgetKit

struct WidgetDataManager {
    
    static func update(
        overdueCount: Int,
        dueTodayCount: Int,
        overdueNames: [String]
    ) {
        let defaults = UserDefaults(
            suiteName: "group.com.zhenyu.CampusEquipment"
        )
        
        defaults?.set(overdueCount, forKey: "overdueCount")
        defaults?.set(dueTodayCount, forKey: "dueTodayCount")
        defaults?.set(overdueNames, forKey: "overdueNames")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
