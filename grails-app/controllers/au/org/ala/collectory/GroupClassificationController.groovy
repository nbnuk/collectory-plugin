package au.org.ala.collectory

import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException

/**
 * Simple webservice providing support licences in the system.
 */
class GroupClassificationController {

    def index() {
        response.setContentType("application/json")
        render (GroupClassification.findAll().collect { [name:it.name] } as JSON)
    }

    def list() {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.sort = params.sort ?: "name"
        [instanceList: GroupClassification.list(params), entityType: 'GroupClassification', instanceTotal: GroupClassification.count()]
    }

    def create() {
        [groupClassificationInstance: new GroupClassification(params)]
    }

    def save() {
        def groupClassificationInstance = new GroupClassification(params)
        if (!groupClassificationInstance.save(flush: true)) {
            render(view: "create", model: [groupClassificationInstance: groupClassificationInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), groupClassificationInstance.id])
        redirect(action: "show", id: groupClassificationInstance.id)
    }

    def show(Long id) {
        def groupClassificationInstance = GroupClassification.get(id)
        if (!groupClassificationInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "list")
            return
        }

        [groupClassificationInstance: groupClassificationInstance]
    }

    def edit(Long id) {
        def groupClassificationInstance = GroupClassification.get(id)
        if (!groupClassificationInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "list")
            return
        }

        [groupClassificationInstance: groupClassificationInstance]
    }

    def update(Long id, Long version) {
        def groupClassificationInstance = GroupClassification.get(id)
        if (!groupClassificationInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (groupClassificationInstance.version > version) {
                groupClassificationInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                        [message(code: 'groupClassification.label', default: 'Group classification')] as Object[],
                        "Another user has updated this Group Classification while you were editing")
                render(view: "edit", model: [groupClassificationInstance: groupClassificationInstance])
                return
            }
        }

        groupClassificationInstance.properties = params

        if (!groupClassificationInstance.save(flush: true)) {
            render(view: "edit", model: [groupClassificationInstance: groupClassificationInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), groupClassificationInstance.id])
        redirect(action: "show", id: groupClassificationInstance.id)
    }

    def delete(Long id) {
        def groupClassificationInstance = GroupClassification.get(id)
        if (!groupClassificationInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "list")
            return
        }

        try {
            groupClassificationInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'groupClassification.label', default: 'Group classification'), id])
            redirect(action: "show", id: id)
        }
    }
}
