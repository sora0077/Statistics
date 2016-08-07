//
//  LaunchManager.swift
//  Statistics
//
//  Created by 林達也 on 2016/08/07.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift


final class Launch: RealmSwift.Object {
    
    private dynamic var uuid: String = ""
    
    dynamic var identifierForVendor: String?
    
    dynamic var deviceVersion: String = ""
    
    dynamic var appVersion: String = ""
    
    dynamic var deviceToken: String?
    
    private dynamic var launchAt = Date()
    
    dynamic var startupTime: Double = 0
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}


private typealias Notification = Foundation.Notification

final class LaunchManager {
    static let shared = LaunchManager(uuid: UUID().uuidString)
    
    private let uuid: String
    
    private var activeAt = Date()

    private init(uuid: String) {
        self.uuid = uuid
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() throws {
        let nc = NotificationCenter.default
        
        let observes: [Notification.Name: Selector] = [
            .UIApplicationDidBecomeActive:
                #selector(self.applicationDidBecomeActive(notification:)),
            .UIApplicationDidEnterBackground:
                #selector(self.applicationDidEnterBackground(notification:)),
            .UIApplicationWillTerminate:
                #selector(self.applicationWillTerminate(notification:))
        ]
        for (name, sel) in observes {
            nc.addObserver(self, selector: sel, name: name, object: nil)
        }
        
        let realm = try statisticsRealm()
        try realm.write {
            let launch = Launch()
            launch.uuid = uuid
            launch.appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            launch.deviceVersion = UIDevice.current().systemVersion
            launch.identifierForVendor = UIDevice.current().identifierForVendor?.uuidString
            
            realm.add(launch)
        }
    }
    
    @objc
    private func applicationDidBecomeActive(notification: Notification) {
        activeAt = Date()
    }
    
    @objc
    private func applicationDidEnterBackground(notification: Notification) {
        
        do {
            let realm = try statisticsRealm()
            if let launch = realm.object(ofType: Launch.self, forPrimaryKey: uuid) {
                try realm.write {
                    launch.startupTime = Date().timeIntervalSince(activeAt)
                }
            }
        } catch {
            
        }
    }
    
    @objc
    private func applicationWillTerminate(notification: Notification) {
    }
}
