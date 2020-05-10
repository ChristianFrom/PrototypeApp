//
//  Data.swift
//  PrototypeApp
//
//  Created by Christian From Rasmussen on 05/05/2020.
//  Copyright © 2020 Christian From. All rights reserved.
//

import SwiftUI

struct Post: Codable, Identifiable {
    let id = UUID()
    var title: String
    var body: String
}

class Api {
    func getPosts(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return print("API URL is not valid") }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            //Sikrer at dataen er den type vi forventer. Gør man for at undgå appen crashe fordi dataen er ikke hvad den forventer.
            guard let data = data else { return print("Data is not valid") }
            
            let posts = try! JSONDecoder().decode([Post].self, from: data)
            //Tillader os at bruge appen, mens den henter fra API'en
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        .resume()
    }
}
