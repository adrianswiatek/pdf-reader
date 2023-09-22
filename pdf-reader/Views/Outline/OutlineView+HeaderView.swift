import SwiftUI

extension OutlineView {
    struct HeaderView: View {
        @Environment(\.colorScheme)
        private var colorScheme: ColorScheme

        @Binding
        private var isShown: Bool

        @Binding
        private var searchTerm: String

        @State
        private var isSearching: Bool

        @FocusState
        private var isSearchFieldFocused: Bool

        init(isOutlineShown isShown: Binding<Bool>, searchTerm: Binding<String>) {
            self._isShown = isShown
            self._isSearching = State(wrappedValue: false)
            self._searchTerm = searchTerm
        }

        var body: some View {
            GeometryReader { proxy in
                HStack(spacing: 8) {
                    Button {
                        withAnimation {
                            isSearching.toggle()
                            isSearchFieldFocused = isSearching
                            searchTerm = ""
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .tint(isSearching ? .activeColor : .accentColor)
                            .padding()
                    }
                    .padding(.leading, 8)

                    if isSearching {
                        HStack {
                            TextField("Search in contents", text: $searchTerm)
                                .focused($isSearchFieldFocused)

                            Button {
                                searchTerm = ""
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                            .disabled(searchTerm == "")
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.background.opacity(0.75))
                        )
                        .frame(maxWidth: proxy.size.width / 3)
                        .transition(.opacity)
                    }

                    Spacer()

                    Button {
                        withAnimation {
                            isShown = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .tint(.accentColor)
                            .padding()
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom)
                .background(Color(uiColor: .secondarySystemBackground))
            }
            .onChange(of: isShown) { _ in
                searchTerm = ""
                isSearching = false
                isSearchFieldFocused = false
            }
        }
    }
}
