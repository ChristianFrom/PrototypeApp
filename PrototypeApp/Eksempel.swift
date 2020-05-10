//
//  Eksempel.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 05/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI
var text = ""

// Funktion som bare ændrer "text" variablen
func tilføjTekst(){
    text = "Tilføjet tekst"
}

struct Eksempel: View {
    var body: some View {
        Text("Hello, World!\n" + "\(text)") // Et "Text View"
            .onAppear(perform: tilføjTekst) // Bruger metoden "tilføjTekst", når Text bliver vist
    }
}

struct Eksempel_Previews: PreviewProvider {
    static var previews: some View {
        Eksempel()
    }
}
