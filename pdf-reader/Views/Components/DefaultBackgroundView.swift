import SwiftUI

struct DefaultBackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 60)
            .fill(.white.opacity(0.8))
            .shadow(color: .blue.opacity(0.25), radius: 0.5, y: 0.5)
    }
}
