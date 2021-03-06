package au.org.ala.collectory

import grails.transaction.Transactional
import groovy.util.slurpersupport.GPathResult
import org.apache.commons.lang.StringUtils

class EmlImportService {

    def serviceMethod() {}

    def dataLoaderService, collectoryAuthService

    /** Collect individual XML para elements together into a single block of text */
    protected def collectParas(GPathResult paras) {
        paras?.list().inject(null, { acc, para -> acc == null ? (para.text()?.trim() ?: "") : acc + " " + (para.text()?.trim() ?: "") })
    }

    protected def collectKeywords(GPathResult keywordSet) {
        keywordSet?.list().inject(null, { acc, keyword -> acc == null ? (keyword.text()?.trim() ?: "") : acc + " " + (keyword.text()?.trim() ?: "") })
    }

    public emlFields = [

        guid:  { eml -> eml.@packageId.toString() },
        pubDescription: { eml -> this.collectParas(eml.dataset.abstract?.para) },
        pubShortDescription: { eml -> StringUtils.left(eml.dataset.abstract?.para[0]?.toString(), 99) },
        name: { eml -> eml.dataset.title.toString() },
        email: { eml ->  eml.dataset.contact?.electronicMailAddress?.text() },
        rights: { eml ->  this.collectParas(eml.dataset.intellectualRights?.para) },
        citation: { eml ->  eml.additionalMetadata?.metadata?.gbif?.citation?.text() },
        techDescription: {eml -> this.collectParas(eml.dataset.additionalInfo?.para) },

        state: { eml ->
            def state = eml.dataset.contact?.address?.administrativeArea?.text()

            if (state)
                state = this.dataLoaderService.massageState(state)
        },

        phone: { eml ->  eml.dataset.contact?.phone?.text() },
        addrCity: { eml -> eml.dataset.contact?.address?.city?:'' },
        addrCountry: { eml -> eml.dataset.contact?.address?.country?:'' },
        addrPostcode: { eml -> eml.dataset.contact?.address?.postalCode?:'' },
        addrState: { eml -> eml.dataset.contact?.address?.administrativeArea?:'' },
        addrStreet: { eml -> eml.dataset.contact?.address?.deliveryPoint?:'' },

        keywords: { eml -> this.collectKeywords(eml.dataset.keywordSet?.keyword) },

        //geographic coverage
        geographicDescription: { eml -> eml.dataset.coverage?.geographicCoverage?.geographicDescription?:'' },
        northBoundingCoordinate: { eml -> eml.dataset.coverage?.geographicCoverage?.boundingCoordinates?.northBoundingCoordinate?:''},
        southBoundingCoordinate: { eml -> eml.dataset.coverage?.geographicCoverage?.boundingCoordinates?.southBoundingCoordinate?:''},
        eastBoundingCoordinate : { eml -> eml.dataset.coverage?.geographicCoverage?.boundingCoordinates?.eastBoundingCoordinate?:''},
        westBoundingCoordinate: { eml -> eml.dataset.coverage?.geographicCoverage?.boundingCoordinates?.westBoundingCoordinate?:''},

        //temporal
        beginDate: { eml -> eml.dataset.coverage?.temporalCoverage?.rangeOfDates?.beginDate?.calendarDate?:''},
        endDate: { eml -> eml.dataset.coverage?.temporalCoverage?.rangeOfDates?.endDate?.calendarDate?:''},

        //additional fields
        purpose: { eml -> eml.dataset.purpose?.para?:''},
        methodStepDescription: { eml -> eml.dataset.methods?.methodStep?.description?.para?:''},
        qualityControlDescription: { eml -> eml.dataset.methods?.qualityControl?.description?.para?:''},

        gbifDoi: { eml ->
            def gbifDoi = null
            eml.dataset.alternateIdentifier?.each {
                def id = it.text()
                if (id && id.startsWith("doi")) {
                    gbifDoi = id
                }
            }
            gbifDoi
        },

        licenseType: { eml -> getLicence(eml).licenseType },
        licenseVersion: { eml -> getLicence(eml).licenseVersion }
    ]


    def getLicence(eml){

        def licenceInfo = [licenseType:'', licenseVersion:'']
        //try and match the acronym to licence
        def rights = this.collectParas(eml.dataset.intellectualRights?.para)

        def matchedLicence = Licence.findByAcronym(rights)
        if(!matchedLicence) {
            //attempt to match the licence
            def licenceUrl = eml.dataset.intellectualRights?.para?.ulink?.@url.text().trim()
            if (licenceUrl.endsWith("/")) licenceUrl = licenceUrl[0..-2] //standardise without trailing '/'
            def licence = Licence.findByUrl(licenceUrl)
            if (licence == null) {
                if (licenceUrl.contains("http://")) {
                    matchedLicence = Licence.findByUrl(licenceUrl.replaceAll("http://", "https://"))
                } else {
                    matchedLicence = Licence.findByUrl(licenceUrl.replaceAll("https://", "http://"))
                }
            } else {
                matchedLicence = licence
            }
        }

        if(matchedLicence){
            licenceInfo.licenseType = matchedLicence.acronym
            licenceInfo.licenseVersion = matchedLicence.licenceVersion
        }

        licenceInfo
    }

    /**
     * Extracts a set of properties from an EML document, populating the
     * supplied dataresource, connection params.
     *
     * @param xml
     * @param dataResource
     * @param connParams
     * @return
     */
    def extractFromEml(eml, dataResource){

        def contacts = []

        emlFields.each { name, accessor ->
            def val = accessor(eml)
            if (val != null)
                dataResource.setProperty(name, val)
        }

        //add a contacts...
        if(eml.dataset.creator){
            eml.dataset.creator.each {
                def contact = addContact(it)
                if(contact){
                    contacts << contact
                }
            }
        }

        if( eml.dataset.metadataProvider
                && eml.dataset.metadataProvider.electronicMailAddress != eml.dataset.creator.electronicMailAddress){

            eml.dataset.metadataProvider.each {
                def contact = addContact(it)
                if(contact){
                    contacts << contact
                }
            }
        }

        contacts
    }

    private def addContact(emlElement){
        def contact = Contact.findByEmail(emlElement.electronicMailAddress)
        if(!contact){
            contact = new Contact()
            contact.firstName = emlElement.individualName.givenName?:''
            contact.lastName = emlElement.individualName.surName?:''
            contact.email = emlElement.electronicMailAddress?:''
            contact.title = emlElement.individualName.salutation?:''
            contact.phone = (emlElement.phone.find{it.@phonetype == "voice"} + emlElement.phone.find{it.attributes().size() == 0}).join(' ') //default phone type is voice if no attribute defining type
            contact.mobile = emlElement.phone.find{it.@phonetype == "mobile"}
            contact.fax = (emlElement.phone.find{it.@phonetype == "facsimile"} + emlElement.phone.find{it.@phonetype == "fax"}).join(' ')

            contact.setUserLastModified(collectoryAuthService.username())
            if(contact.validate()){
                contact.save(flush:true, failOnError: true)
                return contact
            } else {
                contact.errors.each {
                    log.error("Problem creating contact: " + it)
                }
                return null
            }
        }
        contact
    }
}
