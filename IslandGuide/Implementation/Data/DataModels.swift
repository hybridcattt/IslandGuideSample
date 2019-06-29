//
//  DataModels.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import Foundation

struct Spot {
    let id: UUID = UUID()
    let title: String
    let imageName: String
}

struct Activity {
    let id: UUID = UUID()
    let title: String
    let description: String
}

struct Seal {
    let id: UUID = UUID()
    let name: String
    let imageName: String
}
