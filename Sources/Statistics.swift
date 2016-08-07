//
//  Statistics.swift
//  Statistics
//
//  Created by 林達也 on 2016/08/07.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift


public struct LaunchOptions {
    
}

private func configuration() -> Realm.Configuration {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    // swiftlint:disable force_try
    let fileURL = try! URL(fileURLWithPath: path).appendingPathComponent("statistics.realm")
    var config = Realm.Configuration(fileURL: fileURL)
    config.objectTypes = [
        Launch.self,
    ]
    
    return config
}

public func launch(with options: Any? = nil) {
    
    _ = LaunchManager.shared
    
}

func statisticsRealm() -> Realm {
    let realm = try! Realm(configuration: configuration())
    return realm
}
