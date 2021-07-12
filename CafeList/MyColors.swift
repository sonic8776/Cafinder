import UIKit

struct Colors {
    
    static let shared = Colors()
    
    let primaryColor = UIColor(red: 0.43, green: 0.30, blue: 0.25, alpha: 1.0);
    let primaryLightColor = UIColor(red: 0.61, green: 0.47, blue: 0.42, alpha: 1.0);
    let primaryDarkColor = UIColor(red: 0.25, green: 0.14, blue: 0.10, alpha: 1.0);
    let primaryTextColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0);
    let secondaryColor = UIColor(red: 1.00, green: 0.84, blue: 0.25, alpha: 1.0);
    let secondaryLightColor = UIColor(red: 1.00, green: 1.00, blue: 0.45, alpha: 1.0);
    let secondaryDarkColor = UIColor(red: 0.78, green: 0.65, blue: 0.00, alpha: 1.0);
    let secondaryTextColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
    
    // For mrtLabel
    let mrtRed = UIColor(hexString: "#D73E3E")
    let mrtOrange = UIColor(hexString: "#FFA41C")
    let mrtGreen = UIColor(hexString: "#478830")
    let mrtBlue = UIColor(hexString: "#3B8EF0")
    let mrtBrown = UIColor(hexString: "#AD7643")
    let mrtYellow = UIColor(hexString: "#FAE319")
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
