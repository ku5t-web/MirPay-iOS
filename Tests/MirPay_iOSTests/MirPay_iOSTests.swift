
import Testing
import Foundation
@testable import MirPay_iOS

@Test func testCardCreation() {
    let card = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "1234"
    )

    #expect(card.bankName == "Сбер")
    #expect(card.paymentSystem == "Мир")
    #expect(card.lastFourDigits == "1234")
    #expect(card.maskedNumber == "•••• •••• •••• 1234")
}

@Test func testAddCard() {
    var wallet = WalletStore(
    userDefaults: UserDefaults(suiteName: UUID().uuidString)!
)

    let card = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "1234"
    )

    wallet.addCard(card)

    #expect(wallet.cardCount == 1)
    #expect(wallet.cards.first == card)
}

@Test func testRemoveCard() {
    var wallet = WalletStore(
    userDefaults: UserDefaults(suiteName: UUID().uuidString)!
)

    let card = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "1234"
    )

    wallet.addCard(card)
    wallet.removeCard(id: card.id)

    #expect(wallet.cardCount == 0)
}

@Test func testMultipleCards() {
    var wallet = WalletStore(
    userDefaults: UserDefaults(suiteName: UUID().uuidString)!
)

    let firstCard = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "1234"
    )

    let secondCard = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "5678"
    )

    wallet.addCard(firstCard)
    wallet.addCard(secondCard)

    #expect(wallet.cardCount == 2)
}

@Test func testPrimaryCard() {
    var wallet = WalletStore(
        userDefaults: UserDefaults(suiteName: UUID().uuidString)!
    )

    let first = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "1234"
    )

    let second = WalletCard(
        bankName: "Сбер",
        paymentSystem: "Мир",
        lastFourDigits: "5678"
    )

    wallet.addCard(first)
    wallet.addCard(second)

    #expect(wallet.primaryCardID == first.id)

    wallet.setPrimaryCard(id: second.id)

    #expect(wallet.primaryCardID == second.id)
}
