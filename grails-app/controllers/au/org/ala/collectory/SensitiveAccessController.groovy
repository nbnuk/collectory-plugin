package au.org.ala.collectory

import grails.converters.JSON
import groovy.json.JsonSlurper

/**
 * Retrieve the approvals in place for a user.
 */
class SensitiveAccessController {

    def index() { }

    def lookup(){
        def contact = Contact.findByUserId(params.userId) //note, contact.user_id, not e.g. approved_access.contact_id
        def approvals = [
                dataProviders:[],
                //dataResources:[],
                //taxonIds:[],
                dataResourceTaxa:[:]
        ]
        if(contact){
            ApprovedAccess.findAllByContact(contact).each {

                approvals.dataProviders << it.dataProvider.uid

                //def approvedAccessUids = new JsonSlurper().parseText(it.dataResourceUids?:"[]")
                //if(approvedAccessUids == "[]"){
                //    approvedAccessUids = []
                //}

                /* if(approvedAccessUids){
                    // a list has been specified, use this
                    approvals.dataResources.addAll(approvedAccessUids)
                } else {
                    //no list, add all resources for this provider
                    //TODO: remove this, I think: no default access should be given
                    it.dataProvider.getResources().each {
                        approvals.dataResources << it.uid
                    }
                } */

                def approvedAccessUidsWithTaxa = new JsonSlurper().parseText(it.dataResourceTaxa?:"[]")
                if(approvedAccessUidsWithTaxa == "[]"){
                    approvedAccessUidsWithTaxa = []
                }

                if(approvedAccessUidsWithTaxa){
                    approvedAccessUidsWithTaxa.each {
                        def lsid = it.lsid
                        def dr_uid = it.data_resource_uid
                        if (approvals.dataResourceTaxa.containsKey(lsid)) {
                            def existing_dr_uids = approvals.dataResourceTaxa[(lsid)]
                            dr_uid = dr_uid + existing_dr_uids
                        }
                        approvals.dataResourceTaxa << [(lsid) : dr_uid]
                    }

                }
            }
        }
        render approvals as JSON
    }

    /**
     * New lookup for arbitrary whitelistFQ instead of structured taxa-data resource values
     * @return
     */
    def lookupNew(){
        def contact = Contact.findByUserId(params.userId) //note, contact.user_id, not e.g. approved_access.contact_id
        def approvals = [
                dataProviderWhitelist:[:],
        ]
        if(contact){
            ApprovedAccess.findAllByContact(contact).each {
                if (it.useWhitelistingFQ) {

                    approvals.dataProviderWhitelist << [(it.dataProvider.uid) : it.whitelistingFQ]

                }
            }
        }
        render approvals as JSON
    }
}
