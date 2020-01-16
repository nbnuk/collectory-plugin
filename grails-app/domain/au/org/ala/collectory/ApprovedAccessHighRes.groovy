package au.org.ala.collectory

/* import groovy.transform.InheritConstructors

@InheritConstructors
class ApprovedAccessHighRes extends ApprovedAccess {
    //nothing particular at this point
    //re-architect to make a trait and have both types of access implement this?

} */


class ApprovedAccessHighRes implements Serializable {

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    Contact contact
    DataProvider dataProvider

    String dataResourceTaxa = "[]" //JSON  [{"lsid":lsid,"data_resource_uid":[data_resource_uid, data_resource_uid...]},{...}]

    Date dateCreated
    Date lastUpdated
    String userLastModified

    static mapping  = {
        //dataResourceUids type: "text"
        //taxonIDs type: "text"
        dataResourceTaxa type: "text"
    }

    static constraints = {}



    static findAllByContact(Contact contact) {
        def approvedList = []
        ApprovedAccessHighRes.executeQuery("select aa.dataProvider, aa.dataResourceTaxa from ApprovedAccessHighRes aa where aa.contact.userId = ?",[contact.userId]).each {
            approvedList << [dataProvider: it[0], dataResourceTaxa: it[1]]
        }
        approvedList
    }
}

