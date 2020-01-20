package au.org.ala.collectory

import grails.converters.JSON
import groovy.json.JsonSlurper

class HighResAccessController {

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
            ApprovedAccessHighRes.findAllByContact(contact).each {

                approvals.dataProviders << it.dataProvider.uid


                def approvedAccessUidsWithTaxa = new JsonSlurper().parseText(it.dataResourceTaxa?:"[]")
                if(approvedAccessUidsWithTaxa == "[]"){
                    approvedAccessUidsWithTaxa = []
                }

                if(approvedAccessUidsWithTaxa){
                    approvedAccessUidsWithTaxa.each {
                        def lsids = it.lsid
                        def dr_uid = it.data_resource_uid
                        if (approvals.dataResourceTaxa.containsKey(dr_uid)) {
                            def existing_lsids = approvals.dataResourceTaxa[(dr_uid)]
                            lsids = lsids + existing_lsids
                        }
                        approvals.dataResourceTaxa << [(dr_uid) : lsids]
                    }

                }
            }
        }
        render approvals as JSON
    }
}

