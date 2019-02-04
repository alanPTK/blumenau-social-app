import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pcAbout: UIPageControl!
    @IBOutlet weak var svAbout: UIScrollView!
    
    private var currentPage: Int = 0
    private var missionViewController: MissionViewController?
    private var informationViewController: InformationViewController?
    private var actionsViewController: ActionsViewController?
    private var contactViewController: ContactViewController?
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        svAbout.delegate = self
        
        setupView()
    }
    
    /* When the scrolling is finished, update the page control */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        if currentPage == 1 {
            missionViewController?.loadViews()
        }
        
        pcAbout.currentPage = currentPage
    }

    /* Initialize the view components and load the views in the scrollview */
    func setupView() {
        view.backgroundColor = UIColor.backgroundColor()
        pcAbout.pageIndicatorTintColor = UIColor.descColor()
        pcAbout.currentPageIndicatorTintColor = UIColor.titleColor()        
        
        var slides: [UIView] = []
        
        informationViewController = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INFORMATION_VIEW_STORYBOARD_ID) as? InformationViewController
        
        if let infoView = informationViewController?.view {
            slides.append(infoView)
            informationViewController?.tvAbout.text = NSLocalizedString("about", comment: "")
        }
                
        missionViewController = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.MISSION_VIEW_STORYBOARD_ID) as? MissionViewController
        if let missionView = missionViewController?.view {
            slides.append(missionView)
        }
        
        actionsViewController = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.ACTIONS_VIEW_STORYBOARD_ID) as? ActionsViewController
        if let actionsView = actionsViewController?.view {
            slides.append(actionsView)
            actionsViewController?.tvAbout.text = NSLocalizedString("us", comment: "")
        }
        
        contactViewController = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.CONTACT_VIEW_STORYBOARD_ID) as? ContactViewController
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
