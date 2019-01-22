import MSPeekCollectionViewDelegateImplementation

class TestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MSPeekImplementationDelegate {
    
    @IBOutlet weak var cvStuff: UICollectionView!
    var peekImplementation: MSPeekCollectionViewDelegateImplementation!
    
    func peekImplementation(_ peekImplementation: MSPeekCollectionViewDelegateImplementation, didChangeActiveIndexTo activeIndex: Int) {
        print("ok")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let value =  (180 + CGFloat(indexPath.row)*20) / 255
        cell.contentView.backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1)
        return cell
    }
    
    override func viewDidLoad() {
        peekImplementation = MSPeekCollectionViewDelegateImplementation()
        peekImplementation.delegate = self
        
        cvStuff.configureForPeekingDelegate()
        cvStuff.delegate = peekImplementation
        cvStuff.dataSource = self
    }
}
