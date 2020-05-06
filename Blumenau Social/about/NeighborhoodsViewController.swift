import UIKit

class NeighborhoodsViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }        
    
    func setupView() {
        headerView.layer.cornerRadius = 8
    }
}
