import Flutter
import UIKit
import Mobileapi

public class SwiftGohashMobilePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gohash_mobile", binaryMessenger: registrar.messenger())
        let instance = SwiftGohashMobilePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDb":
            if let args = call.arguments as? [String] {
                if args.count == 2 {
                    var error : NSError?
                    let db = MobileapiReadDatabase(args[0], args[1], &error)
                    if let errorMessage = error?.userInfo.description {
                        result(FlutterError.init(code: "NATIVE_ERR",
                                                 message: "Error: " + errorMessage,
                                                 details: nil))
                    } else {
                        result(swiftDatabaseFrom(db: db!))
                    }
                } else {
                    result(FlutterError.init(code: "BAD_ARGS",
                                             message: "Wrong arg count (getDb expects 2 args): " + args.count.description,
                                             details: nil))
                }
            } else {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "Wrong argument types",
                                         details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func swiftDatabaseFrom(db: MobileapiDatabase) -> [String: [[String: Any]]] {
        var result = [String: [[String: Any]]]()
        let iterator = db.iter()!
        while let item = iterator.next() {
            let group = item.group()!
            var entries = [[String: Any]]()
            result[group] = entries
            while let entry = item.next() {
                var loginInfo = [String: Any]()
                loginInfo["name"] = entry.name()!
                loginInfo["username"] = entry.username()!
                loginInfo["password"] = entry.password()!
                loginInfo["url"] = entry.url()!
                loginInfo["description"] = entry.description()!
                loginInfo["updatedAt"] = entry.updatedAt()
                entries.append(loginInfo)
            }
        }
        return result
    }
}
