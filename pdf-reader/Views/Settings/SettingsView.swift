import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @AppStorage(StorageKey.theme)
    private var theme: Settings.Theme = .auto

    var body: some View {
        NavigationStack {
            Form {
                Picker("Theme", selection: $theme) {
                    themeText(.auto)
                    themeText(.dark)
                    themeText(.light)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Color(uiColor: .label).opacity(0.66))
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(theme.toColorScheme())
    }

    private func themeText(_ theme: Settings.Theme) -> some View {
        Text(theme.rawValue.capitalized)
            .tag(theme)
    }
}
