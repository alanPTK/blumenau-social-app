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
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(UIColor.backgroundColor())         
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    func setupView() {
        headerView.layer.cornerRadius = 8
    }
}
