import SwiftUI

enum YapType {
    static let score   = Font.custom(YapFontName.frauncesBlack,    size: 88) // 900 / 0.95
    static let hero    = Font.custom(YapFontName.frauncesBlack,    size: 40) // 900 / 1.05
    static let title   = Font.custom(YapFontName.frauncesBold,     size: 26) // 700 / 1.1
    static let subhead = Font.custom(YapFontName.frauncesSemiBold, size: 20) // 600 / 1.2
    static let bodyL   = Font.custom(YapFontName.nunitoSemiBold,   size: 17) // 600 / 1.5
    static let body    = Font.custom(YapFontName.nunitoSemiBold,   size: 15) // 600 / 1.5
    static let button  = Font.custom(YapFontName.nunitoExtraBold,  size: 17) // 800 / 1
    static let eyebrow = Font.custom(YapFontName.nunitoExtraBold,  size: 12) // 800, +8% tracking, UPPER
    static let caption = Font.custom(YapFontName.nunitoSemiBold,   size: 12) // 600 / 1.3
}
