import SwiftData
import SwiftUI

extension ContentView {
    struct NoContentView: View {
        @Query private var bookProgresses: [BookProgress]

        @Binding private var areSettingsShown: Bool
        @Binding private var isFilePickerShown: Bool
        @Binding private var isHistoryShown: Bool

        @State private var canShowHistory: Bool

        init(
            _ areSettingsShown: Binding<Bool>,
            _ isFilePickerShown: Binding<Bool>,
            _ isHistoryShown: Binding<Bool>
        ) {
            self._areSettingsShown = areSettingsShown
            self._isFilePickerShown = isFilePickerShown
            self._isHistoryShown = isHistoryShown
            self._canShowHistory = State(wrappedValue: false)
        }

        var body: some View {
            ContentUnavailableView {
                Image(systemName: "book.closed.circle.fill")
                    .font(.system(size: 72))
                    .symbolEffect(.scale)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                    .padding(.bottom, 16)

                Text("No PDF document opened")
            } actions: {
                HStack(alignment: .bottom, spacing: 48) {
                    Button {
                        isFilePickerShown.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "doc.fill")
                                .font(.largeTitle)

                            Text("Open")
                                .font(.title3)
                        }
                        .fontWeight(.medium)
                        .padding(.leading)
                        .padding(.vertical)
                    }
                    .buttonStyle(BaseButtonStyle().accented())

                    Button {
                        isHistoryShown.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                                .font(.largeTitle)

                            Text("History")
                                .font(.title3)
                        }
                        .padding(.vertical)
                    }
                    .disabled(!canShowHistory)
                    .buttonStyle(BaseButtonStyle(isActive: canShowHistory))

                    Button {
                        areSettingsShown.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "gearshape")
                                .font(.largeTitle)

                            Text("Settings")
                                .font(.title3)
                        }
                        .padding(.trailing)
                        .padding(.vertical)
                    }
                    .buttonStyle(BaseButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .shadow(radius: 1)
                )
                .padding(.top, 64)
                .frame(maxHeight: 128)
            }
            .background(Color(uiColor: .systemBackground).gradient)
            .onChange(of: bookProgresses, { _, _ in setCanShowHistory() })
            .onAppear(perform: setCanShowHistory)
        }

        private func setCanShowHistory() {
            canShowHistory = !bookProgresses.isEmpty
        }
    }
}
