//
//  StaticAppData.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import Foundation

struct AppData {
    
    var coolSpots: [Spot] = {
        return [
            Spot(title: "The Lighthouse", imageName: "spot4"),
            Spot(title: "Prince Hendrik", imageName: "spot6"),
            Spot(title: "Seal sanctuary", imageName: "spot5"),
            Spot(title: "The Bollekamer", imageName: "spot2"),
            Spot(title: "Beach Pavilion Twaalf", imageName: "spot3"),
            Spot(title: "Sommeltjespad", imageName: "spot1"),
            Spot(title: "The Lighthouse", imageName: "spot4"),
            Spot(title: "Prince Hendrik", imageName: "spot6"),
            Spot(title: "Seal sanctuary", imageName: "spot5"),
        ]
    }()
    
    var funActivities: [Activity] = {
        return [
            Activity(title: "Biking",
                     description: "Biking is the best activity you can find. It's fun, it's sporty, and you can look kind of cool on a bike"),
            Activity(title: "SwiftIsland",
                     description: "This is a special one...."),
            Activity(title: "Running around",
                     description: "Running is not for everyone. But if it's for you, you're in luck! It's still slow enough so you can look around at the nature around"),
            Activity(title: "Petting the seals",
                     description: "Do you dare to do it? Is it even dangerous? Let's find out together!"),
            Activity(title: "Biking",
                     description: "Biking is the best activity you can find. It's fun, it's sporty, and you can look kind of cool on a bike"),
            Activity(title: "Running around",
                     description: "Running is not for everyone. But if it's for you, you're in luck! It's still slow enough so you can look around at the nature around"),
            Activity(title: "SwiftIsland",
                     description: "This is a special one...."),
            Activity(title: "Biking",
                     description: "Biking is the best activity you can find. It's fun, it's sporty, and you can look kind of cool on a bike"),
        ]
    }()
    
    var cuteSeals: [Seal] = {
        return [
            Seal(name: "Dorothy", imageName: "seal1"),
            Seal(name: "Bob", imageName: "seal2"),
            Seal(name: "Robby", imageName: "seal3"),
            Seal(name: "Narnia", imageName: "seal4"),
            Seal(name: "Mary", imageName: "seal5"),
            Seal(name: "Kesha", imageName: "seal1"),
            Seal(name: "J. Doe", imageName: "seal4"),
            Seal(name: "Ada", imageName: "seal2"),
            Seal(name: "Sheldon", imageName: "seal3"),
            Seal(name: "Mary", imageName: "seal5"),
            Seal(name: "Kesha", imageName: "seal1"),
            Seal(name: "J. Doe", imageName: "seal4"),
            Seal(name: "Ada", imageName: "seal2"),
            Seal(name: "Sheldon", imageName: "seal3"),
        ]
    }()
}
