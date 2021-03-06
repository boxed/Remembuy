import SwiftUI

struct Item : Codable, Hashable {
    var id: Int
    var name: String
    var createdAt: Date = Date()
    var user: String
    var completed: Bool = false
    var completedAt: Date?
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

let itemBGColor = Color(red:0.1, green:0.1, blue:0.1)
let itemBGColorCompleted = Color(red:0.05, green:0.05, blue:0.05)

struct ItemView: View {
    @Binding var item: Item
    @ObservedObject var viewModel = ItemsViewModel()
    @State var loading = false
    
    var body: some View {
        Button(action: {
            loading = true
            viewModel.toggleItemCompletion(item: item, onSuccess: {
                item.completed.toggle()
                loading = false
            })
        }) {
            Text(item.name)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .foregroundColor(item.completed ? .gray : .white)
            if loading {
                Image(systemName: "icloud.and.arrow.up")
                .foregroundColor(.white)
            }
            else {
                Image(systemName: "blank")
            }
        }
        .padding(10)
        .background(item.completed ? itemBGColorCompleted : itemBGColor)
        .foregroundColor(item.completed ? .gray : .black)
        .cornerRadius(10)
        .padding(2)
    }
}

struct ContentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var autoCompleteItems: [String] = ["Coke", "Start", "Äppelmos"]
    @State var addItemString: String = ""
    @State var loading: Bool = true
    @ObservedObject var viewModel = ItemsViewModel()
    
    var list: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.items.indices, id:\.self) { i in
                    HStack(alignment:.top) {
                        ItemView(item: $viewModel.items[i])
                    }
                }
            }
        }
    }
    
    var autocompleteView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(autoCompleteItems, id:\.self) { item in
                    Button(action: {
                        viewModel.addItem(item, onSuccess: {
                            addItemString = ""
                            // UIApplication.shared.endEditing()
                        })
                    }) {
                        Text(item)
                        .foregroundColor(.purple)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                "Add item...",
                text: $addItemString,
                onEditingChanged: {_ in },
                onCommit: {
                    addItemString = addItemString.trimmingCharacters(in: .whitespacesAndNewlines)
                    if addItemString == "" {
                        return
                    }
                    viewModel.addItem(addItemString, onSuccess: {
                        addItemString = ""
                    })
                }
            )
            .padding(10)
            .foregroundColor(.white)
                
            if keyboard.currentHeight == 0.0 {
                list
            }
            else {
                autocompleteView
            }

            Spacer()
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
