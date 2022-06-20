//
//  MorfiTimeLocalApp.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 07/09/2021.
//

import SwiftUI

@main
struct MorfiTimeLocalApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView() // FIRST SCREEN
        }
    }
}
