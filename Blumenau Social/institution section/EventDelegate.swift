import MapKit

protocol EventDelegate {
    
    func showAlertWithMessage(message: String)
    func showLocationOnMap(region: MKCoordinateRegion, mark: MKPlacemark)
    func showUserEvent(userEvent: UserEvent)
    
}
