//
//  ContentView.swift
//  Shared
//
//  Created by Anders Hovmöller on 2020-07-19.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var items: [String] = ["foo", "bar", "baz"]
    @State var autoCompleteItems: [String] = ["Coke", "Start", "Äppelmos"]
    @State var addItemString: String = ""
    
    var list: some View {
        VStack(alignment: .leading) {
            ForEach(items, id:\.self) { item in
                HStack(alignment:.top) {
                    Button(action: {}) {
                        Text(item)
                    }.padding(2)
                }
            }
        }
    }
    
    var autocompleteView: some View {
        VStack(alignment: .leading) {
            ForEach(autoCompleteItems, id:\.self) { item in
                Button(action: {}) {
                    Text(item)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Add item...", text: $addItemString)
            if keyboard.currentHeight == 0.0 {
                list
            }
            else {
                autocompleteView
            }

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
