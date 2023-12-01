//
//  ContentView.swift
//  HabitTracker
//
//  Created by Leo  on 01.12.23.
//

import SwiftUI

struct HabitItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let description: String
}

@Observable
class Habits {
    var items = [HabitItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([HabitItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}


struct ContentView: View {
    @State private var habits = Habits()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits.items) { item in // need that for delete stuff later on
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            
                            Spacer()
                            
                            Text(item.description)
                        }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("HabitTracker")
            .toolbar {
                NavigationLink {
                    HabitView(habits: habits)
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.items.remove(atOffsets: offsets)
    }
    
}

#Preview {
    ContentView()
}
