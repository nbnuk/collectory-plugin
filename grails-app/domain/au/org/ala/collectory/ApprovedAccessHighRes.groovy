package au.org.ala.collectory


class ApprovedAccessHighRes implements Serializable {

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    Contact contact
    DataProvider dataProvider

    //note storage one-to-many arrangement is inverted from sensitive data in ApprovedAccess
    String dataResourceTaxa = "[]" //JSON  [{"data_resource_uid":data_resource_uid,"lsid":[lsid, lsid... ]},{...}]

    Date dateCreated
    Date lastUpdated
    String userLastModified

    static mapping  = {
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

