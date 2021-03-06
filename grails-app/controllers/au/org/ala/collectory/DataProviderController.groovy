package au.org.ala.collectory

import au.com.bytecode.opencsv.CSVWriter
import grails.converters.JSON
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

class DataProviderController extends ProviderGroupController {

    def gbifRegistryService
    def authService
    def sensitiveDataService

    DataProviderController() {
        entityName = "DataProvider"
        entityNameLower = "dataProvider"
    }

    def index = {
        redirect(action:"list")
    }

    def myList = {
        def currentUserId = authService.getUserId()
        def contact = Contact.findByUserId(currentUserId)
        def results = []
        if(contact){
            def contactsFor = contact.getContactsFor()
            contactsFor.each {
                if(it.entity.entityType() == DataProvider.getENTITY_TYPE()){
                    results << it.entity
                }
            }
        }
        render (view: 'list', model: [instanceList: results, entityType: 'DataProvider', instanceTotal: results.size()])
    }

    // list all entities
    def list = {
        if (params.message) {
            flash.message = params.message
        }
        params.max = Math.min(params.max ? params.int('max') : 10000, 10000)
        params.sort = params.sort ?: "name"
        ActivityLog.log username(), isAdmin(), Action.LIST
        if(params.q){
            def results = DataProvider.findAllByNameLikeOrAcronymLike('%' + params.q +'%', '%' + params.q +'%');

            [instanceList: results, entityType: 'DataProvider', instanceTotal: results.size()]
        } else {
            [instanceList: DataProvider.list(params), entityType: 'DataProvider', instanceTotal: DataProvider.count()]
        }
    }

    def show = {
        def instance = get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataProvider.label', default: 'Data Provider'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.debug "Ala partner = " + instance.isALAPartner
            ActivityLog.log username(), isAdmin(), instance.uid, Action.VIEW
            
            [instance: instance, contacts: instance.getContacts(), changes: getChanges(instance.uid), hideSensitiveManagement: (grailsApplication.config.sensitive?.hideManagementPanel?:'true').toBoolean()]
        }
    }

    def manageAccess = {
        def instance = get(params.id)
        [instance: instance]
    }

    def specifyAccess = {
        def instance = get(params.id)
        def contact = Contact.findByUserId(params.userId)
        def approvedAccess = ApprovedAccess.findByContactAndDataProvider(contact, instance)

        def sensitiveSpecies = sensitiveDataService.getSensitiveSpeciesForDataProvider(instance.uid)

        def approvedAccessDataResourceTaxa = approvedAccess.dataResourceTaxa?:"[]"

        [instance:instance, contact: contact, sensitiveSpecies: sensitiveSpecies, approvedAccessDataResourceTaxa: approvedAccessDataResourceTaxa]
    }

    boolean isCollectionOrArray(object) {
        [Collection, Object[]].any { it.isAssignableFrom(object.getClass()) }
    }

    def updateSpecifiedAccess = {
        def instance = get(params.id)
        def contact = Contact.findByUserId(params.userId)
        def approvedAccess = ApprovedAccess.findByContactAndDataProvider(contact, instance)

        def dr_taxa_list = params.dataResourceTaxa

        approvedAccess.dataResourceTaxa = dr_taxa_list

        approvedAccess.userLastModified = username()
        approvedAccess.save(flush:true)

        redirect(action:"manageAccess", id:params.id, params:[justSavedUser:params.userId])
    }

    def addUserToApprovedList = {
        def dataProvider = get(params.id)

        log.info("userId " + params.userId)

        //find a user in the collectory - search by CAS ID
        def contact = Contact.findByUserId(params.userId)
        if(!contact){

            contact = Contact.findByEmailIlike(params.email)
            if(contact){
                //update the CAS ID
                contact.setUserId(params.userId)
                contact.userLastModified = "Modified by ${collectoryAuthService.username()})"
                contact.save(flush:true)
            }
        }
        if(!contact){
            //create a new contact in the collectory for this user, we havent seen them before...
            contact = new Contact(
                [
                    userId:params.userId,
                    email:params.email,
                    firstName:params.firstName,
                    lastName: params.lastName,
                    userLastModified: "Modified by ${collectoryAuthService.username()})"
                ]
            )
            contact.save(flush:true)
        }

        def access = new ApprovedAccess()
        access.contact = contact
        access.dataProvider = dataProvider
        access.userLastModified = username()
        access.save(flush:true)

        def result = [success: true]

        //retrieve a list of users with access...
        render result as JSON
    }

    def removeUserToApprovedList = {
        def instance = get(params.id)

        log.info("userId " + params.userId)

        def contact = Contact.findByUserId(params.userId)
        def dataProvider = get(params.id)

        def aa = ApprovedAccess.findByContactAndDataProvider(contact, dataProvider)
        def result = [:]

        if(aa){
            aa.delete(flush:true)
            result.success = true
        } else {
            result.success = false
        }

        //retrieve a list of users with access...
        render result as JSON
    }

    def findUser = {

        //proxy request to user details
        response.setContentType("application/json")
        def url = (grailsApplication.config.userdetails?.url?:"http://set-this-url/") + "userDetails/findUser" + "?q=" + params.q
        log.info("Querying ${url}")
        def js = new JsonSlurper().parse(new URL(url))

        //retrieve a list of IDs of users with access for this provider
        def list = ApprovedAccess.executeQuery("select distinct aa.contact.userId from ApprovedAccess aa where aa.dataProvider.id = ?",
                [Long.valueOf(params.id)])

        js.results.each {
            if(list.contains(it.userId)){
                it.hasAccess = true
            } else {
                it.hasAccess = false
            }
        }
        if (grailsApplication.config.sensitive?.wildcardUserSearch?:'true' == 'false') {
            //only return exact match on email
            js.results.retainAll { it.email == params.q }
        }

        render JsonOutput.toJson(js)
    }

    def findApprovedUsers = {
        def instance = get(params.id)
        def approvedAccess = ApprovedAccess.findAllByDataProvider(instance)
        def contacts = []
        approvedAccess.each {
            contacts << it.contact
        }
        render contacts as JSON
    }

    def downloadApprovedList = {
        def instance = get(params.id)
        def approvedAccess = ApprovedAccess.findAllByDataProvider(instance)
        response.setContentType("text/csv")
        response.setCharacterEncoding("UTF-8")
        response.setHeader("Content-disposition", "attachment;filename=download-approved-users-${instance.uid}.csv")

        def csvWriter = new CSVWriter(new OutputStreamWriter(response.outputStream))
        String[] header = [
                "userID",
                "email",
                "first name",
                "last name"
        ]
        csvWriter.writeNext(header)

        approvedAccess.each {
            def contact =  it.contact
            String[] row = [
                    contact.userId,
                    contact.email,
                    contact.firstName,
                    contact.lastName
            ]
            csvWriter.writeNext(row)
        }
        csvWriter.flush()
    }

    def editConsumers = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "list")
        } else {
            // are they allowed to edit
            if (collectoryAuthService?.userInRole(ProviderGroup.ROLE_ADMIN) || grailsApplication.config.security.cas.bypass.toBoolean()) {
                render(view: '../dataResource/consumers', model:[command: pg, source: params.source])
            } else {
                render("You are not authorised to edit these properties.")
            }
        }
    }

    def updateConsumers = {
        def pg = get(params.id)
        def newConsumers = params.consumers.tokenize(',')
        def oldConsumers = pg.listConsumers()
        // create new links
        newConsumers.each {
            if (!(it in oldConsumers)) {
                def dl = new DataLink(consumer: it, provider: pg.uid).save()
                auditLog(pg, 'INSERT', 'consumer', '', it, dl)
                log.info "created link from ${pg.uid} to ${it}"
            }
        }
        // remove old links - NOTE only for the variety (collection or institution) that has been returned
        oldConsumers.each {
            if (!(it in newConsumers) && it[0..1] == params.source) {
                log.info "deleting link from ${pg.uid} to ${it}"
                def dl = DataLink.findByConsumerAndProvider(it, pg.uid)
                auditLog(pg, 'DELETE', 'consumer', it, '', dl)
                dl.delete()
            }
        }
        flash.message =
            "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
        redirect(action: "show", id: pg.uid)
    }

    def delete = {
        def instance = get(params.id)
        if (instance) {
            if (isAdmin()) {
                /* need to remove it as a parent from all children otherwise they will be deleted */
                def resources = instance.resources as List
                resources.each {
                    instance.removeFromResources it
                    it.userLastModified = username()
                    it.save()  // necessary?
                }
                // remove contact links (does not remove the contact)
                ContactFor.findAllByEntityUid(instance.uid).each {
                    it.delete()
                }
                // now delete
                try {
                    ActivityLog.log username(), isAdmin(), params.id as long, Action.DELETE
                    instance.delete(flush: true)
                    flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
                    redirect(action: "list")
                }
                catch (org.springframework.dao.DataIntegrityViolationException e) {
                    flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
                    redirect(action: "show", id: params.id)
                }
            } else {
                render("You are not authorised to access this page.")
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
            redirect(action: "list")
        }
    }

    def updateAllGBIFRegistrations = {
        gbifRegistryService.updateAllRegistrations()
        flash.message = "${message(code: 'dataProvider.gbif.updateAll', default: 'Updating all GBIF registrations as a background task (please be patient).')}"
        redirect(action: "list")
    }

    def updateGBIFDetails = {
        def pg = get(params.id)
        genericUpdate pg, 'gbif'
    }

    /**
     * This will update the GBIF Registry with the metadata and contacts for the data provider.
     */
    def updateGBIF = {
        def instance = get(params.id)
        if (instance) {
            try {
                if(authService.userInRole(grailsApplication.config.gbifRegistrationRole)) {
                    log.info("[User ${authService.getUserId()}] has selected to update ${instance.uid} in GBIF...")
                    Boolean syncDataResources = params.syncDataResources?:"false".toBoolean()
                    Boolean syncContacts  = params.syncContacts?:"false".toBoolean()
                    gbifRegistryService.updateRegistration(instance, syncContacts, syncDataResources)

                    flash.message = "${message(code: 'dataProvider.gbif.update.success', default: 'GBIF Registration Updated')}"
                } else {
                    flash.message = "User does not have sufficient privileges to perform this. ${grailsApplication.config.gbifRegistrationRole} role required"
                }
            } catch (Exception e) {
                log.error(e.getMessage(), e)
                flash.message = "${e.getMessage()}"
            }

            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Register this data provider as an Organisation with GBIF.
     */
    def registerGBIF = {
        log.info("REGISTERING data partner ${collectoryAuthService.username()}")

        if(authService.userInRole(grailsApplication.config.gbifRegistrationRole)) {
            DataProvider instance = get(params.id)
            if (instance) {
                try {
                    log.info("REGISTERING ${instance.uid}, triggered by user: ${collectoryAuthService.username()}")
                    if (collectoryAuthService.userInRole(grailsApplication.config.gbifRegistrationRole)) {
                        log.info("[User ${authService.getUserId()}] has selected to register ${instance.uid} in GBIF...")

                        Boolean syncDataResources = params.syncDataResources?:"false".toBoolean()
                        Boolean syncContacts  = params.syncContacts?:"false".toBoolean()

                        gbifRegistryService.register(instance, syncContacts, syncDataResources)
                        flash.message = "${message(code: 'dataProvider.gbif.register.success', default: 'Successfully Registered in GBIF')}"
                        instance.save()
                    } else {
                        log.info("REGISTERING FAILED for ${instance.uid}, triggered by user: ${collectoryAuthService.username()} - user not in role")
                        flash.message = "You don't have permission to do register this data partner."
                    }
                } catch (Exception e) {
                    log.error(e.getMessage(), e)
                    flash.message = "${e.getMessage()}"
                }

                redirect(action: "show", id: params.id)
            }
        } else {
            flash.message = "User does not have sufficient privileges to perform this. ${grailsApplication.config.gbifRegistrationRole} role required"
            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Get the instance for this entity based on either uid or DB id.
     *
     * @param id UID or DB id
     * @return the entity of null if not found
     */
    protected ProviderGroup get(id) {
        if (id.size() > 2) {
            if (id[0..1] == DataProvider.ENTITY_PREFIX) {
                return ProviderGroup._get(id)
            }
        }
        // else must be long id
        long dbId
        try {
            dbId = Long.parseLong(id)
        } catch (NumberFormatException e) {
            return null
        }
        return DataProvider.get(dbId)
    }

    /**
     * Return JSON representation of sensitive species held in data provider's datasets
     *
     * @param uid - uid of data provider
     */
    def sensitiveSpeciesForDataProvider = {
        if (params.uid) {
            def sensitiveSpecies = sensitiveDataService.getSensitiveSpeciesForDataProvider(params.uid)
            render sensitiveSpecies as JSON
        } else {
            render(status:400, text: "sensitiveSpeciesForDataProvider: must specify a uid")
        }
    }

    /**
     * Return JSON summary of records for a given species held in data provider's datasets
     *
     * @param uid - uid of data provider
     * @param lsid - lsid of species
     */
    def speciesRecordsForDataProvider = {
        if (params.uid && params.lsid) {
            def speciesRecords = sensitiveDataService.getSpeciesRecordsForDataProvider(params.lsid, params.uid)
            render speciesRecords as JSON
        } else {
            render(status:400, text: "speciesRecordsForDataProvider: must specify uid and lsid")
        }
    }

}
