import Foundation

final class SharedDataManager {

    private let appGroupID = "group.com.zhenyu.CampusEquipment"
    private let pendingKey = "pendingSharedText"

    func readPendingSharedText() -> String? {
        let sharedDefaults = UserDefaults(
            suiteName: appGroupID
        )

        guard let text = sharedDefaults?.string(forKey: pendingKey),
              !text.isEmpty else {
            return nil
        }

        sharedDefaults?.removeObject(forKey: pendingKey)

        return text
    }
}
