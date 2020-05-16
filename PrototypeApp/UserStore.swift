//
//  UserStore.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 15/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import Combine

class UserStore: ObservableObject {
    @Published var isLogged: Bool = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            UserDefaults.standard.set(self.isLogged, forKey: "isLogged")
        }
    }
    @Published var showLogin = false
}
