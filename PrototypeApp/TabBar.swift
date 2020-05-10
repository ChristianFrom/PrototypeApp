//
//  TabBar.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 01/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            Home().tabItem{
                Image(systemName: "house.fill")
                Text("Home")
            }
            ContentView().tabItem{
                Image(systemName: "rectangle.stack.fill")
                Text("Achievements")
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar().previewDevice("iPhone 11 Pro Max")
    }
}
