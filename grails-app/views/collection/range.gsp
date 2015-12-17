<%@ page import="au.org.ala.collectory.Collection;" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <title><g:message code="collection.base.label" default="Edit collection metadata" /></title>
    </head>
    <body>
        <div class="nav">
          <g:if test="${mode == 'create'}">
            <h1><g:message code="collection.range.title01" /></h1>
          </g:if>
          <g:else>
            <h1><g:message code="collection.title.editing" />: ${command.name}</h1>
          </g:else>
        </div>
        <div id="baseForm" class="body">
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="baseForm" action="range">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <div class="dialog">
                    <table class="col-md-12">
                        <tbody>

                        <!-- geographic range -->
                        <tr><td colspan="3"><h3><g:message code="collection.range.title" /></h3></td></tr>
                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="geographicDescription"><g:message code="collection.range.label01" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'geographicDescription', 'errors')} col-md-10">
                                <g:textField name="geographicDescription" class="form-control input-text" value="${command?.geographicDescription}" />
                                <cl:helpText code="collection.geographicDescription"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="states"><g:message code="collection.range.label02" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'states', 'errors')} col-md-10">
                                <g:textField name="states" value="${command?.states}" class="form-control input-text"  />
                                <cl:helpText code="collection.states"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                          <td colspan="2" > <div class="input-text"><g:message code="collection.range.label03" />.</div></td>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="eastCoordinate"><g:message code="collection.range.label04" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'eastCoordinate', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="eastCoordinate" value="${cl.showDecimal(value: command.eastCoordinate)}" class="form-control input-text" />
                                    <cl:helpText code="collection.eastCoordinate"/>
                                </div>
                          </td>
                          <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="westCoordinate"><g:message code="collection.range.label05" /></label>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'westCoordinate', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="westCoordinate" value="${cl.showDecimal(value: command.westCoordinate)}" class="form-control input-text" />
                                    <cl:helpText code="collection.westCoordinate"/>
                                </div>
                          </td>
                          <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="northCoordinate"><g:message code="collection.range.label06" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'northCoordinate', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="northCoordinate" value="${cl.showDecimal(value: command.northCoordinate)}" class="form-control input-text" />
                                    <cl:helpText code="collection.northCoordinate"/>
                                </div>
                            </td>
                            <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="southCoordinate"><g:message code="collection.range.label07" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'southCoordinate', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="southCoordinate" value="${cl.showDecimal(value: command.southCoordinate)}" class="form-control input-text" />
                                    <cl:helpText code="collection.southCoordinate"/>
                                </div>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- taxonomic range -->
                        <tr><td colspan="3"><h3><g:message code="collection.range.title02" /></h3></td></tr>
                       <tr class="prop form-group">
                            <td valign="top" class="checkbox">
                              <label for="kingdomCoverage"><g:message code="collection.range.label08" /></label>
                            </td>
                            <td valign="top" class="checkbox">
                                <cl:checkBoxList name="kingdomCoverage" from="${Collection.kingdoms}" value="${command?.kingdomCoverage}" class="form-control input-text" />
                                <cl:helpText code="collection.kingdomCoverage"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="scientificNames"><g:message code="collection.range.label09" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'scientificNames', 'errors')} col-md-10">
                                <!--richui:autoComplete name="scientificNames" controller="collection" action="scinames" title="sci name"/-->
                              <g:textArea name="scientificNames" value="${command.listScientificNames().join(',')}" class="form-control input-text" />
                              <cl:helpText code="collection.scientificNames"/>
                          </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- stats -->
                        <tr><td colspan="3"><h3><g:message code="collection.range.title03" /></h3></td></tr>
                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="numRecords"><g:message code="collection.numRecords.label" default="Number of specimens" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'numRecords', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="numRecords" value="${cl.showNumber(value: command.numRecords)}"  class="form-control input-text" />
                                    <cl:helpText code="collection.numRecords"/>
                                </div>
                              </td>
                              <cl:helpTD/>
                        </tr>

                       <tr class="prop form-group">
                           <td valign="top" class="name col-md-2">
                              <label for="numRecordsDigitised"><g:message code="collection.numRecordsDigitised.label" default="Number of records digitised" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'numRecordsDigitised', 'errors')} col-md-10">
                                <div class="col-md-3">
                                    <g:textField name="numRecordsDigitised" value="${cl.showNumber(value: command.numRecordsDigitised)}" class="form-control input-text" />
                                    <cl:helpText code="collection.numRecordsDigitised"/>
                                </div>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateRange" value="${message(code:"collection.button.update")}" class="save btn btn-default"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="${message(code:"collection.button.cancel")}" class="cancel btn btn-default"></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
