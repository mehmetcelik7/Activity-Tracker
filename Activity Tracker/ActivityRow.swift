//
//  ActivityRow.swift
//  Activity Tracker
//
//  Created by mehmet Çelik on 8.03.2025.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text("Hours per day: \(activity.hoursPerDay.formatted())")
            }
            Spacer()
            
        }
    }
}

#Preview {
    ActivityRow(activity: .init(name: "Eat Humus",hoursPerDay: 3))
        .padding()
}
