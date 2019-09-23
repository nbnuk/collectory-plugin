<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <g:set var="entityName" value="${entityType}" />
        <g:set var="entityNameLower" value="${cl.controller(type: entityType)}"/>
        <title><g:message code="default.list.label" args="['Group classification']" /></title>
    </head>
    <body>
        <div class="btn-toolbar">
            <ul class="btn-group">
                <li class="btn btn-default"><cl:homeLink/></li>
                <li class="btn btn-default"><span class="glyphicon glyphicon-list"></span><g:link class="list" action="list"> <g:message code="default.list.label" args="['Group classification']"/></g:link></li>
                <li class="btn btn-default"><span class="glyphicon glyphicon-plus"></span><g:link class="create" action="create"> <g:message code="default.new.label" args="['Group classification']"/></g:link></li>
            </ul>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="['Group classification']" /></h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <div class="list">
                <table class="table table-bordered table-striped">
                  <colgroup><col width="100%"/></colgroup>
                    <thead>
                        <tr>
                            <g:sortableColumn property="name" title="${message(code: 'groupClassification.name.label', default: 'Name')}" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${instanceList}" status="i" var="instance">
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link controller="groupClassification" action="show" id="${instance.id}">${fieldValue(bean: instance, field: "name")}</g:link></td>
                      </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="nav">
                <tb:paginate controller="groupClassification" action="list" total="${instanceTotal}" />
            </div>
        </div>
    </body>
</html>
