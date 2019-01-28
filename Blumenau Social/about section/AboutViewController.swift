import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pcAbout: UIPageControl!
    @IBOutlet weak var svAbout: UIScrollView!
    var currentPage: Int = 0
    var missionViewController: MissionViewController?
    var informationViewController: InformationViewController?
    var actionsViewController: ActionsViewController?
    var contactViewController: ContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        svAbout.delegate = self
        
        customizeViewStyle()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        if currentPage == 1 {
            missionViewController?.loadViews()
        }
        
        pcAbout.currentPage = currentPage
    }

    func customizeViewStyle() {
        view.backgroundColor = UIColor.backgroundColor()
        pcAbout.pageIndicatorTintColor = UIColor.descColor()
        pcAbout.currentPageIndicatorTintColor = UIColor.titleColor()        
        
        var slides: [UIView] = []
        
        informationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as? InformationViewController
        
        if let infoView = informationViewController?.view {
            slides.append(infoView)
            informationViewController?.tvAbout.text = NSLocalizedString("about", comment: "")
        }
                
        missionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MissionViewController") as? MissionViewController
        if let missionView = missionViewController?.view {
            slides.append(missionView)
        }
        
        actionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActionsViewController") as? ActionsViewController
        if let actionsView = actionsViewController?.view {
            slides.append(actionsView)
            actionsViewController?.tvAbout.text = NSLocalizedString("us", comment: "")
        }
        
        contactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactViewController") as? ContactViewController
        if let contactView = contactViewController?.view {
            slides.append(contactView)
        }
        
        svAbout.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        svAbout.contentSize = CGSize(width: view.frame.width * 4, height: view.frame.height)
        svAbout.isPagingEnabled = true
        
        pcAbout.numberOfPages = slides.count
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            svAbout.addSubview(slides[i])
        }
        
    }
}
