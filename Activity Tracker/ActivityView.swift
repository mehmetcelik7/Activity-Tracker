//
//  ContentView.swift
//  Activity Tracker
//
//  Created by mehmet Çelik on 8.03.2025.
//

import SwiftUI
import Charts
import SwiftData
struct ActivityView: View {
    
    @Query(sort: \Activity.name, order: .forward)
    var activities: [Activity]
    @Environment(\.modelContext) private var context

    @State private var newName: String = " "
    @State private var hoursPerDay: Double = 0
    @State private var currentActivity: Activity? = nil
    @State private var selectCount: Int?
    
    
    var totalHours: Double {
        var hours = 0.0
        for activity in activities {
            hours += activity.hoursPerDay
        }
        return hours
    }
    
    var remainingHours: Double {
        24 - totalHours
    }
    
    var maxHoursOfSelected: Double {
        remainingHours + hoursPerDay
    }
    
    let step = 1.0
    
    var body: some View {
        NavigationStack {
            VStack {
                
               
           
                Chart {
                    
                    let isSelected: Bool = true
                    
                    ForEach(activities) {
                        activities in
                        
                        SectorMark(angle: .value("Activities",activities.hoursPerDay),
                                   innerRadius: .ratio(0.6),
                                   outerRadius: isSelected ? 1.05 : 0.95,
                                   angularInset: 1)
                        .foregroundStyle(Color.red)
                        .cornerRadius(5)
                    }
                    
                    
                    SectorMark(angle: .value("value",5),
                               innerRadius: .ratio(0.6),
                               outerRadius: .ratio(0.95),
                               angularInset: 1)
                    .foregroundStyle(Color.red)
                    .cornerRadius(5)
                    
                    SectorMark(angle: .value("value",3),
                               innerRadius: .ratio(0.6),
                               outerRadius: .ratio(1.05),
                               angularInset: 1)
                    .foregroundStyle(Color.blue)

                    
                    
                    SectorMark(angle: .value("value",17),
                               innerRadius: .ratio(0.6),
                               outerRadius: .ratio(0.95),
                               angularInset: 1)
                    .foregroundStyle(Color.yellow)

                }
                .chartAngleSelection(value: $selectCount)
                
                List(activities) {
                    activity in
                    Text(activity.name)
                        .onTapGesture {
                            withAnimation {
                                currentActivity = activity
                                hoursPerDay = activity.hoursPerDay
                            }
                        }
                }.listStyle(.plain)
                    .scrollIndicators(.hidden)
                
                if let currentActivity {
                    Slider(value: $hoursPerDay, in: 0...maxHoursOfSelected, step: step)
                        .onChange(of: hoursPerDay) {   oldValue, newValue in
                            //TODO:
                        }
                }
                Button("Add") {
                    addActivity()
                }.buttonStyle(.borderedProminent)
                    .disabled(remainingHours <= 0)
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
    
    private func addActivity() {
        //TODO: Implement
    }
    private func deleteActivity(at offsets: IndexSet) {
        //TODO: Implement
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: Activity.self)
}
