<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="${grailsApplication.config.skin.layout}" />
		<g:set var="entityName" value="${message(code: 'groupClassification.label', default: 'Group classification')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="btn-toolbar">
			<ul class="btn-group">
				<li class="btn  btn-default"><cl:homeLink/></li>
				<li class="btn  btn-default"><span class="glyphicon glyphicon-list"></span><g:link class="list" action="list"> <g:message code="default.list.label" args="[entityName]"/></g:link></li>
				<li class="btn  btn-default"><span class="glyphicon glyphicon-plus"></span><g:link class="create" action="create"> <g:message code="default.new.label" args="[entityName]"/></g:link></li>
			</ul>
		</div>
		<div id="show-groupClassification" class="content scaffold-show" role="main">
			<h1><g:fieldValue bean="${groupClassificationInstance}" field="name"/></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<div class="property-list groupClassification">

				<br/>
			</div>
			<div class="btn-toolbar">
				<g:form class="btn-group">
					<g:hiddenField name="id" value="${groupClassificationInstance?.id}"/>
					<g:link class="edit btn btn-default" action="edit" id="${groupClassificationInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
						<g:actionSubmit class="delete btn btn-danger" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
					</cl:ifGranted>
				</g:form>
			</div>
		</div>
	</body>
</html>
