<%@ page import="au.org.ala.collectory.Contact" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1 ><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${contactInstance}">
            <div class="errors">
                <g:renderErrors bean="${contactInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
              <g:hiddenField name="returnTo" value="${returnTo}"/>
                <div class="dialog col-md-12">
                    <table class="col-md-8">
                        <tbody>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="title"><g:message code="contact.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'title', 'errors')} col-md-6">
                                    <g:select name="title" from="${contactInstance.constraints.title.inList}" value="${contactInstance?.title}" valueMessagePrefix="contact.title" noSelection="['': '']" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="firstName"><g:message code="contact.firstName.label" default="First Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'firstName', 'errors')} col-md-6">
                                    <g:textArea name="firstName" cols="40" rows="5" value="${contactInstance?.firstName}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="lastName"><g:message code="contact.lastName.label" default="Last Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'lastName', 'errors')} col-md-6">
                                    <g:textArea name="lastName" cols="40" rows="5" value="${contactInstance?.lastName}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="phone"><g:message code="contact.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'phone', 'errors')} col-md-6">
                                    <g:textField name="phone" maxlength="45" value="${contactInstance?.phone}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="mobile"><g:message code="contact.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'mobile', 'errors')} col-md-6">
                                    <g:textField name="mobile" maxlength="45" value="${contactInstance?.mobile}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="email"><g:message code="contact.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'email', 'errors')} col-md-6">
                                    <g:textField name="email" value="${contactInstance?.email}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="fax"><g:message code="contact.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'fax', 'errors')} col-md-6">
                                    <g:textField name="fax" maxlength="45" value="${contactInstance?.fax}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="notes"><g:message code="contact.notes.label" default="Notes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'notes', 'errors')} col-md-6">
                                    <g:textArea name="notes" cols="40" rows="5" value="${contactInstance?.notes}" class="form-control input-text"/>
                                </td>
                            </tr>
                        
                           <tr class="prop form-group">
                                <td valign="top" class="name col-md-2">
                                    <label for="publish"><g:message code="contact.publish.label" default="Publish" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'publish', 'errors')} col-md-1">
                                    <g:checkBox name="publish" value="${contactInstance?.publish}" class="form-control input-text" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save btn btn-default" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
