import SwiftUI

struct YapCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(YapSpacing.s6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(YapColor.studioGrape, in: RoundedRectangle(cornerRadius: YapRadius.xl))
            .yapShadow(YapShadow.card)
    }
}
