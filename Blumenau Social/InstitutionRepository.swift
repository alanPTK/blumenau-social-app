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
                
                donation.id = donationData.id
                donation.title = donationData.title
                
                institution.donations.append(donation)
            }
            
            for causeData in institutionData.causes {
                let cause = InstitutionCause()
                
                cause.id = causeData.id
                cause.title = causeData.title
                
                institution.causes.append(cause)
            }
            
            for pictureData in institutionData.pictures {
                let picture = InstitutionPicture()
                
                picture.id = pictureData.id
                picture.link = pictureData.link
                
                institution.pictures.append(picture)
            }
            
            for aboutData in institutionData.about {
                let about = InstitutionAbout()
                
                about.id = aboutData.id
                about.title = aboutData.title
                about.information = aboutData.information
                
                institution.about.append(about)
            }
            
            saveInstitution(institution)
        }
    }
    
    func createInstitutionDonationWithData(institutionDonationData: DonationX) {
        
    }
    
    func saveInstitution(_ institution: Institution) {
        try! realm.write {
            realm.add(institution, update: true)
        }
    }        
}
