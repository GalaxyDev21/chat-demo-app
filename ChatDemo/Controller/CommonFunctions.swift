import UIKit

class CommonFunctions: NSObject {

    // MARK: - get Target list from UserDefaults

    class func getTargetList() -> [[String: Any]] {
        var getList = [[String: Any]]()
        if CommonFunctions.unarchive(archivedURL: CommonFunctions.archiveURL(keyName: "SavedTargetList")!) != nil {
            getList = CommonFunctions.unarchive(archivedURL: CommonFunctions.archiveURL(keyName: "SavedTargetList")!) ?? [[:]]
        }
        return getList
    }

    // MARK: - Locally Save Data

    class func archiveURL(keyName: String) -> URL? {
        guard let documentURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent("\(keyName).data")
    }

    class func archive(customObject: [[String: Any]], keyName: String) {
        guard let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: customObject, requiringSecureCoding: true),
              let archiveURL = archiveURL(keyName: keyName) else {
            return
        }

        try? dataToBeArchived.write(to: archiveURL)
    }

    class func unarchive(archivedURL: URL) -> [[String: Any]]? {
        guard let archivedData = try? Data(contentsOf: archivedURL),
              let customObject = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [[String: Any]] else {
            return nil
        }
        return customObject
    }
}
