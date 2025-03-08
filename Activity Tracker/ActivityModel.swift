//
//  ActivityModel.swift
//  Activity Tracker
//
//  Created by mehmet Çelik on 8.03.2025.
//

import Foundation
import SwiftData

@Model

class Activity {
    @Attribute(.unique) var id : String = UUID().uuidString
    
    var name : String
    var hoursPerDay: Double
    
    init(id: String, name: String, hoursPerDay: Double = 0) {
        self.id = id
        self.name = name
        self.hoursPerDay = hoursPerDay
    }
}
