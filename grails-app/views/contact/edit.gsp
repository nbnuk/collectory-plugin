
<%@ page import="au.org.ala.collectory.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span></li>
            <li><span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${contactInstance}">
            <div class="errors">
                <g:renderErrors bean="${contactInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${contactInstance?.id}" />
                <g:hiddenField name="version" value="${contactInstance?.version}" />
                <g:hiddenField name="returnTo" value="${returnTo}" />
                <div class="col-md-12">
                    <table>
                        <tbody>
                            <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                  <label for="title"><g:message code="contact.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'title', 'errors')} col-md-8">
                                    <g:select name="title" from="${contactInstance.constraints.title.inList}" value="${contactInstance?.title}" valueMessagePrefix="contact.title" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="firstName"><g:message code="contact.firstName.label" default="First Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'firstName', 'errors')} col-md-8">
                                    <g:textField name="firstName" class="input-xlarge" value="${contactInstance?.firstName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="lastName"><g:message code="contact.lastName.label" default="Last Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'lastName', 'errors')} col-md-8">
                                    <g:textField name="lastName" class="input-xlarge" value="${contactInstance?.lastName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="phone"><g:message code="contact.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'phone', 'errors')} col-md-8">
                                    <g:textField name="phone" maxlength="45" value="${contactInstance?.phone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="mobile"><g:message code="contact.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'mobile', 'errors')} col-md-8">
                                    <g:textField name="mobile" maxlength="45" value="${contactInstance?.mobile}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="email"><g:message code="contact.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'email', 'errors')} col-md-8">
                                    <g:textField name="email" value="${contactInstance?.email}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="fax"><g:message code="contact.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'fax', 'errors')} col-md-8">
                                    <g:textField name="fax"  maxlength="45" value="${contactInstance?.fax}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="notes"><g:message code="contact.notes.label" default="Notes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'notes', 'errors')} col-md-8">
                                    <g:textArea name="notes" class="form-control input-text" cols="40" rows="5" value="${contactInstance?.notes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop form-group">
                                <td valign="top" class="name">
                                  <label for="publish"><g:message code="contact.publish.label" default="Publish" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'publish', 'errors')} col-md-8">
                                    <g:checkBox name="publish" value="${contactInstance?.publish}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save btn btn-default" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-danger" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
