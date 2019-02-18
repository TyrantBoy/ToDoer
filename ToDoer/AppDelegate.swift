//
//  AppDelegate.swift
//  ToDoer
//
//  Created by Donald Nguyen on 2/15/19.
//  Copyright © 2019 Idunknow. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //location of realm file
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
            _ = try Realm()
        } catch {
            print("error init realm \(error)")
        }
        
        
        return true
    }


}

