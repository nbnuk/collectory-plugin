package au.org.ala.collectory

class ApprovedAccess implements Serializable {

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    Contact contact
    DataProvider dataProvider
    //String dataResourceUids = "[]" //JSON array of dataResourceUids
    //String taxonIDs = "[]" //JSON array of taxonIDs
    String dataResourceTaxa = "[]" //JSON  [{"lsid":lsid,"data_resource_uid":[data_resource_uid, data_resource_uid...]},{...}]
    String whitelistingFQ = ""          //new generic whitelisting format. NOTE: multiple fq params need to be aggregated into a single composite clause as per fq=a:1&fq=b:2...fq=n:p ---> fq=(a:1 AND b:2 ... AND n:p)
    Boolean useWhitelistingFQ = false   //whether to use new format or not
    Date dateCreated
    Date lastUpdated
    String userLastModified

    static mapping  = {
        //dataResourceUids type: "text"
        //taxonIDs type: "text"
        dataResourceTaxa type: "text"
        whitelistingFQ type: "text"
    }

    static constraints = {}

    //def findByContactAndDataProvider(Contact contact, Long instance) {
    //
    //}

    static findAllByContact(Contact contact) {
        def approvedList = []
        ApprovedAccess.executeQuery("select aa.dataProvider, aa.dataResourceTaxa, aa.whitelistingFQ, aa.useWhitelistingFQ from ApprovedAccess aa where aa.contact.userId = ?",[contact.userId]).each {
            approvedList << [dataProvider: it[0], dataResourceTaxa: it[1], whitelistingFQ: it[2], useWhitelistingFQ: it[3]]
        }
        approvedList
    }
}

//findAllByContact(contact)
//findByContactAndDataProvider(contact, instance)
//findAllByDataProvider(instance)
//save(flush:true)
//executeQuery("select distinct aa.contact.userId from ApprovedAccess aa where aa.dataProvider.id = ?",[Long.valueOf(params.id)])