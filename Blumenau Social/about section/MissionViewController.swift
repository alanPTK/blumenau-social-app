import UIKit

class MissionViewController: UIViewController {

    @IBOutlet weak var lbOurVision: UILabel!
    @IBOutlet weak var tvOurVision: UITextView!
    
    @IBOutlet weak var lbOurMission: UILabel!
    @IBOutlet weak var tvOurMission: UITextView!
    
    @IBOutlet weak var lbOurValues: UILabel!
    @IBOutlet weak var lbPlurality: UILabel!
    @IBOutlet weak var lbDevelopment: UILabel!
    @IBOutlet weak var lbCommitment: UILabel!
    @IBOutlet weak var lbConnection: UILabel!
    @IBOutlet weak var lbSharing: UILabel!
    @IBOutlet weak var lvLoveForTheCause: UILabel!
    @IBOutlet weak var lbVolunteering: UILabel!
    
    private var viewsToAnimate: [UIView] = []
    private var currentIndex: Int = 0
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        viewsToAnimate.append(lbOurVision)
        viewsToAnimate.append(tvOurVision)
        viewsToAnimate.append(lbOurMission)
        viewsToAnimate.append(tvOurMission)
        viewsToAnimate.append(lbOurValues)
        viewsToAnimate.append(lbVolunteering)
        viewsToAnimate.append(lvLoveForTheCause)
        viewsToAnimate.append(lbSharing)
        viewsToAnimate.append(lbConnection)
        viewsToAnimate.append(lbCommitment)
        viewsToAnimate.append(lbDevelopment)
        viewsToAnimate.append(lbPlurality)
    }
    
    /* Initialize the view components */
    func setupView() {
        lbOurVision.alpha = 0
        tvOurVision.alpha = 0
        
        lbOurMission.alpha = 0
        tvOurMission.alpha = 0
        
        lbOurValues.alpha = 0
        lbPlurality.alpha = 0
        lbDevelopment.alpha = 0
        lbCommitment.alpha = 0
        lbConnection.alpha = 0
        lbSharing.alpha = 0
        lvLoveForTheCause.alpha = 0
        lbVolunteering.alpha = 0
    }
    
    /* Animate the view components */
    func animateView(viewToAnimate: UIView) {
        var duration = 0.4
        
        if currentIndex >= 5 {
            duration = 0.3
        }
        
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.alpha = 1
        }) {(finished) in
            if finished {
                if self.currentIndex < self.viewsToAnimate.count-1 {
                    self.currentIndex += 1
                    self.animateView(viewToAnimate: self.viewsToAnimate[self.currentIndex])
                }
            }
        }
    }
    
    /* Start the view animation */
    func loadViews() {
        animateView(viewToAnimate: viewsToAnimate.first!)
    }    
}
