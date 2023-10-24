import SwiftUI

extension ContentView {
    struct PageNumber: View {
        @Environment(PageListener.self)
        private var pageListener: PageListener

        private var page: Page? {
            pageListener.currentPage
        }

        private var canShowPageNumber: Bool {
            page?.hasPageNumber == true
        }

        private var canShowPageLabel: Bool {
            page?.hasPageLabel == true && page?.arePropertiesTheSame == false
        }

        var body: some View {
            if canShowPageNumber {
                HStack(spacing: 2) {
                    if canShowPageLabel {
                        Text(page?.formattedPageNumber ?? "")
                            .fontWeight(.thin)
                        Text(" | ")
                            .fontWeight(.thin)
                        Text(page?.pageLabel ?? "")
                            .fontWeight(.medium)
                    } else {
                        Text(page?.formattedPageNumber ?? "")
                            .fontWeight(.medium)
                    }
                }
                .foregroundColor(.black.opacity(0.75))
                .padding(.horizontal, 8)
                .frame(height: 44)
                .frame(minWidth: 44)
                .background(RoundedRectangle(cornerRadius: 60)
                    .fill(.white.opacity(0.66))
                    .shadow(color: .blue.opacity(0.33), radius: 0.5, y: 0.5))
            } else {
                EmptyView()
            }
        }
    }
}
