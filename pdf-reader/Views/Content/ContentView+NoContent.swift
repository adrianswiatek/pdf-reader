import SwiftData
import SwiftUI

extension ContentView {
    struct NoContentView: View {
        @Query
        private var bookProgresses: [BookProgress]

        @Binding
        private var isFilePickerShown: Bool

        @Binding
        private var arePreviousShown: Bool

        @State
        private var canShowPrevious: Bool

        init(
            _ isFilePickerShown: Binding<Bool>,
            _ arePreviousShown: Binding<Bool>
        ) {
            self._isFilePickerShown = isFilePickerShown
            self._arePreviousShown = arePreviousShown
            self._canShowPrevious = State(wrappedValue: false)
        }

        var body: some View {
            ContentUnavailableView {
                Image(systemName: "book.closed.circle.fill")
                    .font(.system(size: 72))
                    .symbolEffect(.scale)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                    .padding(.bottom, 4)

                Text("No PDF document opened")
            } actions: {
                HStack(alignment: .bottom, spacing: 64) {
                    Button {
                        isFilePickerShown.toggle()
                    } label: {
                        VStack {
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
                        arePreviousShown.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "list.bullet")
                                .font(.largeTitle)
                                .padding(.bottom, 3)

                            Text("Previous")
                                .font(.title3)
                        }
                        .padding(.trailing)
                        .padding(.vertical)
                    }
                    .disabled(!canShowPrevious)
                    .buttonStyle(BaseButtonStyle(isActive: canShowPrevious))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .shadow(radius: 1)
                )
                .padding()
            }
            .background(Color(uiColor: .systemBackground).gradient)
            .onChange(of: bookProgresses, { _, _ in setCanShowPrevious() })
            .onAppear(perform: setCanShowPrevious)
        }

        private func setCanShowPrevious() {
            canShowPrevious = !bookProgresses.isEmpty
        }
    }
}
