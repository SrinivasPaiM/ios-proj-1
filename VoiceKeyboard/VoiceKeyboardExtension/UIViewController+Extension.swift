import UIKit

extension UIViewController {
    /// Helper to safely access keyboard's text document proxy
    var currentTextInput: UITextDocumentProxy? {
        guard let controller = self as? UIInputViewController else {
            return nil
        }
        return controller.textDocumentProxy
    }
}
