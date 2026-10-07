import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        let sharedText = contentText ?? ""

        let defaults = UserDefaults(
            suiteName: "group.com.zhenyu.CampusEquipment"
        )

        defaults?.set(sharedText, forKey: "pendingSharedText")
        defaults?.synchronize()

        self.extensionContext?.completeRequest(
            returningItems: [],
            completionHandler: nil
        )
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
