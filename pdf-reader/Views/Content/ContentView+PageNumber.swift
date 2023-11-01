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
                        Text(page?.pageNumber ?? "")
                            .fontWeight(.thin)
                        Text(" | ")
                            .fontWeight(.thin)
                        Text(page?.pageLabel ?? "")
                            .fontWeight(.medium)
                    } else {
                        Text(page?.pageNumber ?? "")
                            .fontWeight(.medium)
                    }
                }
                .foregroundColor(.black)
                .padding(.horizontal, 8)
                .frame(height: 44)
                .frame(minWidth: 44)
                .background(DefaultBackgroundView())
            }
        }
    }
}
