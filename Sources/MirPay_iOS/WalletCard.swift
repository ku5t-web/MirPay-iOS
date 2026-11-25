
import Foundation

public struct WalletCard: Identifiable, Equatable, Codable {

    public let id: UUID
    public let bankName: String
    public let paymentSystem: String
    public let lastFourDigits: String

    public init(
        bankName: String,
        paymentSystem: String,
        lastFourDigits: String
    ) {
        self.id = UUID()
        self.bankName = bankName
        self.paymentSystem = paymentSystem
        self.lastFourDigits = lastFourDigits
    }

    public var maskedNumber: String {
        "•••• •••• •••• \(lastFourDigits)"
    }
}
