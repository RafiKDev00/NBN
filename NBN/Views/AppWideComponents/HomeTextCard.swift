import SwiftUI

struct HomeTextCard<Header: View, Content: View>: View {
    let width: CGFloat?
    let height: CGFloat?
    let header: Header
    let content: Content

    init(width: CGFloat? = nil, height: CGFloat? = nil, @ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.width = width
        self.height = height
        self.header = header()
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            Divider()
                .background(NBNColors.bondiBlue)

            content
                .padding(12)

            Spacer()
        }
        .applyFrame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(NBNColors.alabaster)
                .shadow(color: NBNColors.bondiBlue.opacity(0.4), radius: 4, x: 0, y: 0)
        )
    }
}

private extension View {
    @ViewBuilder
    func applyFrame(width: CGFloat?, height: CGFloat?) -> some View {
        if let width = width, let height = height {
            frame(width: width, height: height, alignment: .topLeading)
        } else if let width = width {
            frame(width: width, alignment: .topLeading)
        } else if let height = height {
            frame(height: height, alignment: .topLeading)
        } else {
            frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}


#Preview {
    HStack(spacing: 12) {
        HomeTextCard(width: 200, height: 180) {
            Text("Header")
                .font(.headline)
        } content: {
            Text("Body content goes here")
                .font(.subheadline)
        }

        HomeTextCard(height: 180) {
            Text("Another")
        } content: {
            VStack(alignment: .leading, spacing: 4) {
                Text("More content")
                Text("Even more")
            }
        }
    }
    .padding()
}
