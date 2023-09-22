import SwiftUI

extension ContentView {
    struct PageNumber: View {
        @EnvironmentObject
        private var currentPageListener: CurrentPageListener

        private var canShowPageNumberWithPageLabel: Bool {
            if currentPageListener.hasPageLabel {
                return currentPageListener.pageNumber != currentPageListener.pageLabel
            }
            return false
        }

        var body: some View {
            if currentPageListener.hasPageNumber {
                HStack(spacing: 2) {
                    if canShowPageNumberWithPageLabel {
                        Text(currentPageListener.pageNumber ?? "")
                            .fontWeight(.thin)
                        Text(" | ")
                            .fontWeight(.thin)
                        Text(currentPageListener.pageLabel ?? "")
                            .fontWeight(.medium)
                    } else {
                        Text(currentPageListener.pageNumber ?? "")
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
