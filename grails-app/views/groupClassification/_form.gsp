<%@ page import="au.org.ala.collectory.GroupClassification" %>

<div class="fieldcontain ${hasErrors(bean: groupClassificationInstance, field: 'name', 'error')} form-group">
    <label for="name"><cl:required><g:message code="groupClassificationInstance.name.label" default="Name" /></cl:required></label>
    <g:textField name="name" class="form-control" maxlength="200" required="" value="${groupClassificationInstance?.name}"/>
</div>



