//
//  UpdateStore.swift
//  MySwiftUIApp
//
//  Created by Fedor Sychev on 03.09.2021.
//

import SwiftUI
import Combine

class UpdateStore: ObservableObject {
    @Published var updates: [Update] = updateData
}
