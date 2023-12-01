//
//  HabitView.swift
//  HabitTracker
//
//  Created by Leo  on 01.12.23.
//

import SwiftUI

struct HabitView: View {
    @Environment(\.dismiss) var dismiss
    @State private var type = "Exercise"
    @State private var description = ""
    @State private var title = "Name"
    @State private var showingAddHabits = false
    @State private var newHabit = ""
    @State private var types = UserDefaults.standard.stringArray(forKey: "HabitTypes") ?? ["Exercise", "Music", "Learning"]
    
    var habits: Habits
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Description", text: $description)
            }
            .toolbar {
                Button("Save") {
                    let item = HabitItem(name: title, type: type, description: description)
                    habits.items.append(item)
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Add Type") {
                        showingAddHabits = true
                    }
                }
            }
            .sheet(isPresented: $showingAddHabits) {
                VStack(spacing: 20){
                    TextField("Add Habit Type", text: $newHabit)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add to Habits") {
                        addNewHabitType()
                        showingAddHabits = false
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
            .disabled(title == "")
        }
    }
    
    private func addNewHabitType() {
        types.append(newHabit)
        newHabit = ""
        UserDefaults.standard.set(types, forKey: "HabitTypes")
    }
}

#Preview {
    HabitView(habits: Habits())
}
