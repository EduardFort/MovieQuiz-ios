import Foundation
import UIKit

class AlertPresenter: AlertProtocol{
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel?) {
        guard let model = model else {return}
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
