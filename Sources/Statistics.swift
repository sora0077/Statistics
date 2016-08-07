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
    public var encryptionKey: Data?
    
    public init() {}
}

private var launchOptions: LaunchOptions!

public func launch(with options: LaunchOptions = LaunchOptions()) throws {
    launchOptions = options
    try LaunchManager.shared.setup()
}

public func statisticsRealm() throws -> Realm {
    let realm = try Realm(configuration: configuration)
    return realm
}

private let configuration: Realm.Configuration = {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    // swiftlint:disable force_try
    let fileURL = try! URL(fileURLWithPath: path).appendingPathComponent("statistics.realm")
    var config = Realm.Configuration(fileURL: fileURL, encryptionKey: launchOptions.encryptionKey)
    config.objectTypes = [
        Launch.self,
    ]
    
    return config
}()
