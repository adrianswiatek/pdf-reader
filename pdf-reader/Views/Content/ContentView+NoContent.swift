import SwiftUI

extension ContentView {
    struct NoContentView: View {
        @Binding
        private var isFilePickerShown: Bool

        @Binding
        private var arePreviousShown: Bool

        init(
            _ isFilePickerShown: Binding<Bool>,
            _ arePreviousShown: Binding<Bool>
        ) {
            self._isFilePickerShown = isFilePickerShown
            self._arePreviousShown = arePreviousShown
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
                HStack(alignment: .bottom, spacing: 32) {
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
                        .foregroundColor(Color(uiColor: .label).opacity(0.75))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding()
                    }

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
                        .fontWeight(.regular)
                        .foregroundColor(Color(uiColor: .label).opacity(0.75))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding()
                    }
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
        }
    }
}
