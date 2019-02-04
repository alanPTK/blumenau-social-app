import EventKit
import RealmSwift
import MapKit
import CoreLocation

class EventPresenter {
    
    private var delegate: EventDelegate
    private let userRepository = UserRepository()
    
    init(delegate: EventDelegate) {
        self.delegate = delegate
    }
    
    /* Add the event to the user calendar */
    func addEventToCalendar(event: InstitutionEvent) {
        let eventRef = ThreadSafeReference(to: event)
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                let realm = try! Realm()
                let eventToAdd = realm.resolve(eventRef)
                
                let calendarEvent = EKEvent(eventStore: eventStore)
                
                guard let day = eventToAdd?.day, let month = eventToAdd?.month, let year = eventToAdd?.year, let startHour = eventToAdd?.startHour, let endHour = eventToAdd?.endHour else {
                    
                    self.delegate.showAlertWithMessage(message: NSLocalizedString("Error adding the event to you calendar. Please, try again later.", comment: ""))
                    
                    return
                }
                
                let startDate = Utils.shared.createDateWithValues(day: day, month: month, year: year, hour: startHour)
                let endDate = Utils.shared.createDateWithValues(day: day, month: month, year: year, hour: endHour)
                
                calendarEvent.title = eventToAdd?.title
                calendarEvent.startDate = startDate
                calendarEvent.endDate = endDate
                calendarEvent.notes = eventToAdd!.desc
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    
                    self.delegate.showAlertWithMessage(message: NSLocalizedString("Event added successfully. We wait for you there !", comment: ""))
                    
                } catch _ as NSError {
                    self.delegate.showAlertWithMessage(message: NSLocalizedString("Error adding the event to you calendar. Please, try again later.", comment: ""))
                }
            } else {
                self.delegate.showAlertWithMessage(message: NSLocalizedString("Error adding the event to you calendar. Did you allowed us to add events ? Please, check and try again.", comment: ""))                
            }
        }
    }
    
    /* Remove the event from the user calendar */
    func removeEventFromCalendar(event: InstitutionEvent) {
        let eventRef = ThreadSafeReference(to: event)
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            let realm = try! Realm()
            let eventToRemove = realm.resolve(eventRef)
            
            guard let day = eventToRemove?.day, let month = eventToRemove?.month, let year = eventToRemove?.year, let startHour = eventToRemove?.startHour, let endHour = eventToRemove?.endHour else {
                
                self.delegate.showAlertWithMessage(message: NSLocalizedString("Error removing the event from you calendar. Please, try again later.", comment: ""))
                
                return
            }
            
            let startDate = Utils.shared.createDateWithValues(day: day, month: month, year: year, hour: startHour)
            let endDate = Utils.shared.createDateWithValues(day: day, month: month, year: year, hour: endHour)
            
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let eventFromStore = eventStore.events(matching: predicate)
            
            if eventFromStore.first != nil {
                do {
                    try eventStore.remove(eventFromStore.first!, span: .thisEvent)
                } catch _ {
                    self.delegate.showAlertWithMessage(message: NSLocalizedString("Error removing the event from you calendar. Please, try again later.", comment: ""))
                }
            }
        }
    }
    
    /* Open the Maps application with the event location */
    func openMapsApp(map: MKMapView, event: InstitutionEvent) {
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: map.region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: map.region.span)
        ]
        
        let placemark = MKPlacemark(coordinate: map.centerCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = event.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    /* Get the event location from its address and show in the map */
    func getEventLocationOnMap(event: InstitutionEvent, map: MKMapView) {
        let location = event.address
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                var region = map.region
                
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                region.center = location.coordinate
                region.span = span
                
                self?.delegate.showLocationOnMap(region: region, mark: mark)
            }
        }
    }
    
    /* Get the user event */
    func getUserEvent(event: InstitutionEvent) {
        if let userEvent = userRepository.getUserEvent(event) {
            delegate.showUserEvent(userEvent: userEvent)
        }
    }
    
    /* Change the user attendance status in the event */
    func changeAttendanceStatusForEvent(event: InstitutionEvent, attendance: Bool) {
        userRepository.changeAttendanceStatusForEvent(event: event, attendance: attendance)
    }

}
