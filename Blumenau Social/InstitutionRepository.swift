import UIKit
import RealmSwift

class InstitutionRepository: NSObject {
    
    private var realm: Realm    
    
    override init() {
        realm = try! Realm()
    }

    func getAllInstitutions() -> Results<Institution> {
        return realm.objects(Institution.self)
    }
    
    func createInstitutionWithData(institutionsData: Institutions) {
        for institutionData in institutionsData.institutions {
            let institution: Institution = Institution()
            
            institution.id = institutionData.id
            institution.title = institutionData.title
            institution.subtitle = institutionData.subtitle
            institution.address = institutionData.address
            institution.phone = institutionData.phone
            institution.mail = institutionData.mail
            institution.responsible = institutionData.responsible
            institution.workingHours = institutionData.working_hours
            institution.scope = institutionData.scope
            institution.volunteers = institutionData.volunteers
            
            for donationData in institutionData.donations {
                let donation = InstitutionDonation()
                
                donation.id = institutionDonationNextID()
                donation.title = donationData.title
                
                institution.donations.append(donation)
                saveDonation(donation)
            }
            
            for causeData in institutionData.causes {
                let cause = InstitutionCause()
                
                cause.id = institutionCauseNextID()
                cause.title = causeData.title
                
                institution.causes.append(cause)
                saveCause(cause)
            }
            
            for pictureData in institutionData.pictures {
                let picture = InstitutionPicture()
                
                picture.id = institutionPictureNextID()
                picture.link = pictureData.link
                
                institution.pictures.append(picture)
                savePicture(picture)
            }
            
            for aboutData in institutionData.about {
                let about = InstitutionAbout()
                
                about.id = institutionAboutNextID()
                about.title = aboutData.title
                about.information = aboutData.information
                
                institution.about.append(about)
                saveAbout(about)
            }
            
            saveInstitution(institution)
        }
    }
    
    func institutionDonationNextID() -> Int {
        return (realm.objects(InstitutionDonation.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func institutionCauseNextID() -> Int {
        return (realm.objects(InstitutionCause.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func institutionPictureNextID() -> Int {
        return (realm.objects(InstitutionPicture.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func institutionAboutNextID() -> Int {
        return (realm.objects(InstitutionAbout.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func saveInstitution(_ institution: Institution) {
        try! realm.write {
            realm.add(institution, update: true)
        }
    }
    
    func saveDonation(_ donation: InstitutionDonation) {
        try! realm.write {
            realm.add(donation, update: true)
        }
    }
    
    func savePicture(_ picture: InstitutionPicture) {
        try! realm.write {
            realm.add(picture, update: true)
        }
    }
    
    func saveAbout(_ about: InstitutionAbout) {
        try! realm.write {
            realm.add(about, update: true)
        }
    }
    
    func saveCause(_ cause: InstitutionCause) {
        try! realm.write {
            realm.add(cause, update: true)
        }
    }
}
