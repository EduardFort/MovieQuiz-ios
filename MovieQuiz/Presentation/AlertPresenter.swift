import Foundation
import UIKit

class AlertPresenter:  AlertProtocol {
    
    weak var viewController: MovieQuizViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController as? MovieQuizViewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game Result"
        let action = UIAlertAction(title: model.buttonText, style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
        
    }
}
