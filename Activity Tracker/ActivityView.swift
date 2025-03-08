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

    @State private var newName: String = ""
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
                
               
                if activities.isEmpty {
                    ContentUnavailableView("Enter an Activity",systemImage: "list.dash")
                }else{
                    Chart {
                        
                        
                        ForEach(activities) {
                            activity in
                            let isSelected: Bool = currentActivity?.name == activity.name

                            SectorMark(angle: .value("Activities",activity.hoursPerDay),
                                       innerRadius: .ratio(0.6),
                                       outerRadius: .ratio(isSelected ? 1.05 : 0.95),
                                       angularInset: 1)
                            .foregroundStyle(by: .value("activity", activity.name))
                            .cornerRadius(5)
                            .opacity(isSelected ? 1 : 0.7)
                        }
                        
                    }
                    .chartAngleSelection(value: $selectCount)
                    .chartBackground{ _ in
                        VStack{
                            Image(systemName: "figure.walk")
                                .imageScale(.large)
                                .foregroundStyle(.blue)
                            
                            if let currentActivity {
                                let truncateName = String(currentActivity.name.prefix(15))
                                
                                Text(truncateName)
                                    
                            }
                        }
                        
                    }
                }
              
                
                List {
                    ForEach(activities) {
                        activity in
                        ActivityRow(activity: activity)
                            .contentShape(Rectangle())
                            .listRowBackground(
                                currentActivity?.name == activity.name ? Color.blue.opacity(0.3) : Color.clear
                            )
                            .onTapGesture {
                                withAnimation {
                                    currentActivity = activity
                                    hoursPerDay = activity.hoursPerDay
                                }
                            }
                    }
                    .onDelete(perform: deleteActivity)
                   
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
                TextField("Enter new activity",text: $newName)
                    .padding()
                    .background(Color.blue.gradient.opacity(0.3))
                    .clipShape(.rect(cornerRadius: 10))
            
                
                if let currentActivity {
                    Slider(value: $hoursPerDay, in: 0...maxHoursOfSelected, step: step)
                        .onChange(of: hoursPerDay) {   oldValue, newValue in
                          
                            if let index = self.activities.firstIndex(where: { $0.name == currentActivity.name }) {
                                activities[index].hoursPerDay = newValue
                            }
                            
                        }
                }
                Button("Add") {
                    addActivity()
                }.buttonStyle(.borderedProminent)
                    .disabled(remainingHours <= 0)
            }
            .padding()
            .navigationTitle("Activity Tracker")
            .toolbar { EditButton()
                    .onChange(of: selectCount) { oldValue, newValue in
                        
                        if let newValue {
                            withAnimation {
                                getSelected(value: newValue)
                            }
                        }
                        
                    }
                
            }
        }
    }
    
    private func addActivity() {
        if newName.count > 2 && !activities.contains(where: { $0.name.lowercased() == newName.lowercased()}) {
            
            
            hoursPerDay = 0
            let activity = Activity(name: newName, hoursPerDay: hoursPerDay)
            
            context
                .insert(activity)
            
            newName = ""
            
            currentActivity = activity
            
        }
    }
    private func deleteActivity(at offsets: IndexSet) {

        offsets
            .forEach { index in
                let activity = activities[index]
                context.delete(activity)
            }
    }
    
    private func getSelected(value: Int) {

        var cumulativeTotal = 0.0
        if let activity = activities.first(where: { cumulativeTotal += $0.hoursPerDay;
            return Int(cumulativeTotal) >= value
        }) {
            currentActivity = activity
        }
    }
    
}

#Preview {
    ActivityView()
        .modelContainer(for: Activity.self)
}
