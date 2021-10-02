//
//  DataStore.swift
//  MySwiftUIApp
//
//  Created by Fedor Sychev on 11.09.2021.
//

import SwiftUI
import Combine

class DataStore: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        Api().getPosts { (posts) in
            self.posts = posts
        }
    }
}
