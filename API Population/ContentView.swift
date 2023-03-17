//
//  ContentView.swift
//  API Population
//
//  Created by James on 3/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var entries = [Entry]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(entries) { entry in
                NavigationLink {
                    Text(entry.nation)
                        .font(.system(size: 45))
                    Text(entry.year)
                        .font(.system(size: 45))
                    Text("\(entry.population)")
                        .font(.system(size: 45))
                } label: {
                    Text(entry.nation)
                    Text(entry.year)
                    
                }
            }
            .navigationTitle("Annual US Population")
        }
        .task {
            await getAPIResults()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the API categories"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func getAPIResults() async {
        let query = "https://datausa.io/api/data?drilldowns=Nation&measures=Population"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Entries.self, from: data) {
                    entries = decodedResponse.entries
                    return
                }
            }
        }
        showingAlert = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Entries: Codable {
    var entries: [Entry]
    
    enum CodingKeys: String, CodingKey {
        case entries = "data"
    }
}

struct Entry: Identifiable, Codable {
    var id = UUID()
    var nation: String
    var year: String
    var population: Int
    
    
    enum CodingKeys: String, CodingKey {
        case nation = "Nation"
        case year = "Year"
        case population = "Population"
    }
    
    
    
    
}
