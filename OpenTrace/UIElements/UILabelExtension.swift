import UIKit

extension UILabel {
    func semiBold(text: String) {
        guard let lblTxt = self.text,
            let range = lblTxt.range(of: text)  else { return }
        let nsRange = NSRange(range, in: lblTxt)
        let attrString = NSMutableAttributedString(string: lblTxt)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Muli-SemiBold", size: self.font.pointSize)!, range: nsRange)
        self.attributedText = attrString
    }
    
    func bold(text: String) {
        guard let lblTxt = self.text,
            let range = lblTxt.range(of: text)  else { return }
        let nsRange = NSRange(range, in: lblTxt)
        let attrString = NSMutableAttributedString(string: lblTxt)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: self.font.pointSize), range: nsRange)
        self.attributedText = attrString
    }
}
