package au.org.ala.collectory

class ApprovedAccess implements Serializable {

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    Contact contact
    DataProvider dataProvider
    //String dataResourceUids = "[]" //JSON array of dataResourceUids
    //String taxonIDs = "[]" //JSON array of taxonIDs
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

    //def findByContactAndDataProvider(Contact contact, Long instance) {
    //
    //}
}

//findAllByContact(contact)
//findByContactAndDataProvider(contact, instance)
//findAllByDataProvider(instance)
//save(flush:true)
//executeQuery("select distinct aa.contact.userId from ApprovedAccess aa where aa.dataProvider.id = ?",[Long.valueOf(params.id)])