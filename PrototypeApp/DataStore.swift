//
//  DataStore.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 05/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
import Combine

class DataStore: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        Api().getPosts { (posts)  in
            self.posts = posts
        }
    }
}
