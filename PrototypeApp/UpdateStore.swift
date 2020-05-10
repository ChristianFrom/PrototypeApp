//
//  UpdateStore.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 01/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import Combine

class UpdateStore: ObservableObject {
    @Published var updates: [Update] = updateData
}
