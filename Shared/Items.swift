import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    
    @Published var items: [Item] = [Item(id: 1, name: "foo", user: "bar")]
    var cancellationToken: AnyCancellable?
    
    init() {
        cancellationToken = RemembuyAPI.get(.items)
           .mapError({ (error) -> Error in
               print(error)
               return error
           })
           .sink(receiveCompletion: { _ in },
                 receiveValue: {
                   self.items = $0
           })
    }
    
    func addItem(_ s: String, onSuccess: @escaping () -> Void) {
        cancellationToken = RemembuyAPI.post(.add, parameters: ["name": s])
           .mapError({ (error) -> Error in
               print(error)
               return error
           })
           .sink(receiveCompletion: { _ in },
                 receiveValue: {
                    self.items.insert($0, at: 0)
                    onSuccess()
           })
    }
}
