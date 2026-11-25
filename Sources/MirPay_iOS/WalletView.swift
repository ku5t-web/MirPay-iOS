
#if canImport(SwiftUI)
import SwiftUI

public struct WalletView: View {

    @State private var wallet = WalletStore()
    @State private var showAddCard = false
    @State private var showSettings = false
    @State private var cardToDelete: WalletCard?
@State private var showDeleteConfirmation = false

    public init() {}

    public var body: some View {
        ZStack {
            Color(red: 0.045, green: 0.043, blue: 0.055)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Заголовок
                    HStack {
                        HStack(spacing: 0) {
                            Text("mirpay")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)

                            Text(".")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(Color(red: 0.68, green: 0.52, blue: 0.88))
                        }

                        Spacer()

                        Button {
    showSettings = true
} label: {
    Image(systemName: "gearshape")
        .font(.system(size: 21))
        .foregroundStyle(.white.opacity(0.7))
}
                    }
                    .padding(.top, 20)

                    // Заголовок кошелька
                    VStack(alignment: .leading, spacing: 8) {
                        Text("МОЙ КОШЕЛЁК")
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(3)
                            .foregroundStyle(.white.opacity(0.45))

                        Text("\(wallet.cardCount) карты")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundStyle(.white)
                    }

                    // Список карт
                    ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 16) {
        ForEach(wallet.cards) { card in
            cardView(card)
    .frame(width: 310)
    .onTapGesture {
        wallet.setPrimaryCard(id: card.id)
    }
    .contextMenu {
        if wallet.primaryCardID != card.id {
            Button {
                wallet.setPrimaryCard(id: card.id)
            } label: {
                Label("Сделать основной", systemImage: "star")
            }
        }

       Button(role: .destructive) {
    cardToDelete = card
    showDeleteConfirmation = true
} label: {
    Label("Удалить карту", systemImage: "trash")
}
    }
        }
    }
    .scrollTargetLayout()
}
.contentMargins(.horizontal, 4)
.scrollTargetBehavior(.viewAligned)

                    // Добавление карты
                    Button {
                        showAddCard = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 23))

                            Text("Добавить карту")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundStyle(Color(red: 0.78, green: 0.68, blue: 0.91))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(
                            Color.white.opacity(0.035)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    Color.purple.opacity(0.35),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 5])
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 30)

                    Text("MIRPAY  ·  DIGITAL WALLET")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.25))
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 30)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAddCard) {
            AddCardView { card in
                wallet.addCard(card)
            }
        }
                .alert("Удалить карту?", isPresented: $showDeleteConfirmation) {
                    .sheet(isPresented: $showSettings) {
    NavigationStack {
        Form {
            Section("MirPay") {
                HStack {
                    Text("Версия")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Сохранено карт")
                    Spacer()
                    Text("\(wallet.cardCount)")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Бесконтактная оплата") {
                Label("NFC пока не подключён", systemImage: "wave.3.right")
                    .foregroundStyle(.orange)

                Text("Реальные платежи станут доступны только после подключения необходимых платёжных технологий и разрешений Apple.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                Text("MirPay — цифровой кошелёк")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Готово") {
                    showSettings = false
                }
            }
        }
    }
    .preferredColorScheme(.dark)
}
            Button("Отмена", role: .cancel) {
                cardToDelete = nil
            }

            Button("Удалить", role: .destructive) {
                if let card = cardToDelete {
                    wallet.removeCard(id: card.id)
                }
                cardToDelete = nil
            }
        } message: {
            Text("Карта будет удалена из кошелька.")
        }
    }

    // Металлическая карточка
    private func cardView(_ card: WalletCard) -> some View {
        let isPrimary = wallet.primaryCardID == card.id
        VStack(alignment: .leading, spacing: 28) {

            HStack {
                Text(card.bankName.uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .tracking(2)

                Spacer()

                Text(card.paymentSystem.uppercased())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color(red: 0.82, green: 0.72, blue: 0.95))
            }

            Text(card.maskedNumber)
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .tracking(1)
                .padding(.vertical, 5)

            HStack {
                Text("МОЯ КАРТА")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.5))

                Spacer()

                Image(systemName: "wave.3.right")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.94))
            }
        }
        .foregroundStyle(.white)
        .padding(24)
        .background {
            LinearGradient(
                colors: [
                    Color(red: 0.20, green: 0.18, blue: 0.24),
                    Color(red: 0.12, green: 0.11, blue: 0.16),
                    Color(red: 0.25, green: 0.20, blue: 0.31)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .overlay {
    RoundedRectangle(cornerRadius: 22)
        .stroke(
            LinearGradient(
                colors: isPrimary
                    ? [.white.opacity(0.4), .purple.opacity(0.8)]
                    : [.white.opacity(0.25), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: isPrimary ? 1.8 : 1
        )
}
.shadow(
    color: isPrimary ? .purple.opacity(0.3) : .clear,
    radius: isPrimary ? 18 : 0
)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

// Экран добавления карты
private struct AddCardView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var bankName = "Сбер"
    @State private var paymentSystem = "Мир"
    @State private var lastFourDigits = ""

    let onSave: (WalletCard) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Информация о карте") {
                    TextField("Банк", text: $bankName)

                    TextField("Платёжная система", text: $paymentSystem)

                    TextField("Последние 4 цифры", text: $lastFourDigits)
                        .keyboardType(.numberPad)
                        .onChange(of: lastFourDigits) { _, newValue in
                            lastFourDigits = String(
                                newValue.filter(\.isNumber).prefix(4)
                            )
                        }
                }

                Section {
                    Button("Добавить в кошелёк") {
                        let card = WalletCard(
                            bankName: bankName,
                            paymentSystem: paymentSystem,
                            lastFourDigits: lastFourDigits
                        )

                        onSave(card)
                        dismiss()
                    }
                    .disabled(
                        bankName.isEmpty ||
                        paymentSystem.isEmpty ||
                        lastFourDigits.count != 4
                    )
                }
            }
            .navigationTitle("Новая карта")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
#endif
