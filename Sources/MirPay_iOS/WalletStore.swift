
import Foundation

public struct WalletStore {

    private let storageKey = "mirpay.saved.cards"
    private let userDefaults: UserDefaults
    private let primaryKey = "mirpay.primary.card"

public private(set) var primaryCardID: UUID? {
    didSet {
        if let id = primaryCardID {
            userDefaults.set(id.uuidString, forKey: primaryKey)
        } else {
            userDefaults.removeObject(forKey: primaryKey)
        }
    }
}

    public private(set) var cards: [WalletCard] = [] {
        didSet {
            saveCards()
        }
    }

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let savedID = userDefaults.string(forKey: "mirpay.primary.card") {
    self.primaryCardID = UUID(uuidString: savedID)
}

        if let data = userDefaults.data(forKey: storageKey),
           let savedCards = try? JSONDecoder().decode(
               [WalletCard].self,
               from: data
           ) {
            self.cards = savedCards
        }
    }

   public mutating func addCard(_ card: WalletCard) {
    cards.append(card)

    if primaryCardID == nil {
        primaryCardID = card.id
    }
}
public mutating func setPrimaryCard(id: UUID) {
    guard cards.contains(where: { $0.id == id }) else {
        return
    }

    primaryCardID = id
}

    public mutating func removeCard(id: UUID) {
    cards.removeAll { $0.id == id }

    if primaryCardID == id {
        primaryCardID = cards.first?.id
    }
}

    public var cardCount: Int {
        cards.count
    }

    private func saveCards() {
        guard let data = try? JSONEncoder().encode(cards) else {
            return
        }

        userDefaults.set(data, forKey: storageKey)
    }
}
