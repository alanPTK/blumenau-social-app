import Foundation

struct Constants {
    
    static let FILTERS_DOWNLOAD_LINK = "https://dl.dropboxusercontent.com/s/dse0ddxn7ebd910/filters.json"
    //static let INSTITUTIONS_DOWNLOAD_LINK = "https://dl.dropboxusercontent.com/s/uuf2dg05gyybmiq/institutions.json"
    static let INSTITUTIONS_DOWNLOAD_LINK = "https://dl.dropboxusercontent.com/s/ajn4mcs3x8n0iys/institutions2.json"
    static let EVENTS_DOWNLOAD_LINK = "https://dl.dropboxusercontent.com/s/t3x97p4j95pgpt3/events.json"
    
    static let CONTACT_EMAIL = "contato@blumenausocial.org"
    
    //storyboard view identifiers
    static let FILTER_VIEW_STORYBOARD_ID = "FilterViewController"
    static let INITIAL_PROFILE_VIEW_STORYBOARD_ID = "InitialProfileViewController"
    static let INSTITUTION_VIEW_STORYBOARD_ID = "InstitutionViewController"
    static let INFORMATION_VIEW_STORYBOARD_ID = "InformationViewController"
    static let MISSION_VIEW_STORYBOARD_ID = "MissionViewController"
    static let ACTIONS_VIEW_STORYBOARD_ID = "ActionsViewController"
    static let CONTACT_VIEW_STORYBOARD_ID = "ContactViewController"
    static let FULL_IMAGE_VIEW_STORYBOARD_ID = "FullImageViewController"
    static let INITIAL_VIEW_STORYBOARD_ID = "initialViewController"
    static let EVENT_VIEW_STORYBOARD_ID = "EventViewController"
    
    //storyboard identifiers
    static let MAIN_STORYBOARD_NAME = "Main"
    static let ABOUT_STORYBOARD_NAME = "About"
    static let PROFILE_STORYBOARD_NAME = "Profile"
    static let FILTER_STORYBOARD_NAME = "Filter"
    static let INSTITUTION_STORYBOARD_NAME = "Institution"
    static let DIALOG_STORYBOARD_NAME = "Dialog"
    
    //cell identifiers
    static let INSTITUTION_GENERAL_INFORMATION_CELL_IDENTIFIER = "InstitutionGeneralInformationCell"
    static let INSTITUTION_MATCH_CELL_IDENTIFIER = "InstitutionMatchCell"
    static let FILTER_CELL_IDENTIFIER = "filterCell"
    static let SEE_MORE_CELL_IDENTIFIER = "seeMoreCell"
    static let ACTION_IMAGE_CELL_IDENTIFIER = "actionImageCell"
    static let EVENT_CARD_CELL_IDENTIFIER = "EventCardCell"
    static let INSTITUTION_CARD_CELL_IDENTIFIER = "InstitutionCardCell"
    
    //social network profiles
    static let FACEBOOK_APP_URL = "fb://profile/249674518521338";
    static let FACEBOOK_WEB_URL = "https://www.facebook.com/BlumenauSocial/";
    static let INSTAGRAM_APP_URL = "instagram://user?username=blumenausocial";
    static let INSTAGRAM_WEB_URL = "https://instagram.com/blumenausocial";
    static let ALAN_LINKEDIN_APP_URL = "linkedin://profile/alan-filipe-cardozo-fabeni-102502142";
    static let ALAN_LINKEDIN_WEB_URL = "https://www.linkedin.com/in/alan-filipe-cardozo-fabeni-102502142/";
    static let THIAGO_LINKEDIN_APP_URL = "linkedin://profile/thiago-krepsky-bennertz-785a67162";
    static let THIAGO_LINKEDIN_WEB_URL = "https://www.linkedin.com/in/thiago-krepsky-bennertz-785a67162/";
    
    //notification names
    static let SHOW_INSTITUTION_NOTIFICATION_NAME = "showInstitution";
    static let SHOW_EVENT_NOTIFICATION_NAME = "showEvent";
}
