//
//  randomuserApp.swift
//  randomuser
//
//  Created by Pau on 22/1/25.
//

import SwiftUI

@main
struct randomuserApp: App {
    var body: some Scene {
        WindowGroup {
            let networkClient = URLSessionNetworkClient()
            let remoteDataSource = RandomUserAPIDataSource(networkClient: networkClient)
            ContentView()
        }
    }
}
