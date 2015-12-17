<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <title><g:message code="collection.base.label" default="Edit collection metadata" /></title>
    </head>
    <body id="body-wrapper">
        <div class="nav">
          <g:if test="${mode == 'create'}">
            <h1><g:message code="collection.des.title" /></h1>
          </g:if>
          <g:else>
            <h1><g:message code="collection.title.editing" />: ${command.name}</h1>
          </g:else>
        </div>
        <div id="baseForm" >
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="baseForm" action="base">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <table class="col-md-12">
                    <tbody>

                    <!-- public description -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="pubDescription"><g:message code="providerGroup.pubDescription.label" default="Public Description" /></label>
                        </td>
                        <td valign="top" class="value col-md-8 ${hasErrors(bean: command, field: 'pubDescription', 'errors')} col-md-8">
                            <g:textArea name="pubDescription" class=" form-control col-md-8" rows="${cl.textAreaHeight(text:command.pubDescription)}" value="${command.pubDescription}" />
                            <cl:helpText code="collection.pubDescription"/>
                          </td>
                          <cl:helpTD/>
                    </tr>

                    <!-- tech description -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="techDescription"><g:message code="providerGroup.techDescription.label" default="Technical Description" /></label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: command, field: 'techDescription', 'errors')} col-md-8">
                            <g:textArea name="techDescription"  class=" form-control" rows="${cl.textAreaHeight(text:command.techDescription)}" value="${command?.techDescription}" />
                            <cl:helpText code="collection.techDescription"/>
                          </td>
                          <cl:helpTD/>
                    </tr>

                    <!-- focus -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="focus"><g:message code="providerGroup.focus.label" default="Focus" /></label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: command, field: 'focus', 'errors')} col-md-8">
                            <g:textArea name="focus" class="form-control" rows="${cl.textAreaHeight(text:command.focus)}" value="${command?.focus}" />
                            <cl:helpText code="collection.focus"/>
                        </td>
                      <cl:helpTD/>
                    </tr>
                    <!-- type -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="collectionType"><g:message code="collection.collectionType.label" default="Collection Type" /></label>
                        </td>
                            <td valign="top" class="col-md-10 checkbox ${hasErrors(bean: command, field: 'collectionType', 'errors')}">
                                <div class="col-md-1"></div>
                                <cl:checkboxSelect class="checkbox col-md-2" name="collectionType" from="${command.collectionTypes}" value="${command.listCollectionTypes()}" multiple="yes" valueMessagePrefix="collection.collectionType" noSelection="['': '']" />
                                <cl:helpText code="collection.collectionType"/>
                            </td>
                      <td><img class="helpButton" alt="help" src="${resource(dir:'images/skin', file:'help.gif')}" onclick="toggleHelp(this);"/></td>
                    </tr>

                    <!-- growth status -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="active"><g:message code="providerGroup.sources.active.label" default="Status" /></label>
                        </td>
                        <div class="col-md-4">
                            <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'active', 'errors')} ">
                                <div class="col-md-4">
                                    <g:select class="form-control" name="active" from="${command.constraints.active.inList}" value="${command?.active}" valueMessagePrefix="infoSource.active" noSelection="['': '']" />
                                    <cl:helpText code="collection.active"/>
                                </div>
                            </td>
                        </div>
                      <cl:helpTD/>
                    </tr>

                    <!-- start date -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="startDate"><g:message code="collection.des.startdate" /></label>
                        </td>
                        <div class="col-md-4">
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'startDate', 'errors')} ">
                                <div class="col-md-4">
                                    <g:textField name="startDate" maxlength="45" value="${command?.startDate}" class="form-control" />
                                    <cl:helpText code="collection.startDate"/>
                                </div>
                            </td>
                         </div>
                        <cl:helpTD/>
                    </tr>

                    <!-- end date -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="endDate"><g:message code="collection.des.enddate" /></label>
                        </td>
                        <div class="col-md-4">
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'endDate', 'errors')} ">
                                <div class="col-md-4">
                                    <g:textField name="endDate" maxlength="45" value="${command?.endDate}" class="form-control"/>
                                    <cl:helpText code="collection.endDate"/>
                                </div>
                            </td>
                        </div>
                        <cl:helpTD/>
                    </tr>

                    <!-- keywords -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="keywords"><g:message code="collection.keywords.label" default="Keywords" /></label>
                        </td>
                        <div class="col-md-4">
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'keywords', 'errors')} ">
                                <div class="col-md-4">
                                    <g:textField name="keywords" value="${command?.listKeywords().join(',')}" class="form-control" />
                                    <cl:helpText code="collection.keywords"/>
                                </div>
                            </td>
                        </div>
                        <cl:helpTD/>
                    </tr>

                    <!-- sub-collections -->
                    <tr class="prop form-group">
                        <td valign="top" class="name col-md-2">
                          <label for="subCollections"><g:message code="scope.subCollections.label" default="Sub-collections" /></label>
                        </td>
                        <div class="col-md-6">
                            <td id="subCollections" valign="top" class="value ${hasErrors(bean: command, field: 'scope.subCollections', 'errors')}">
                              <p><g:message code="collection.des.des01" />.</p>
                                <div class="col-md-6">
                                  <table class="shy"><colgroup><col width="50%"/><col width="50%"/></colgroup>
                                    <tr><td><g:message code="collection.des.de02" /></td><td><g:message code="collection.des.des03" /></td></tr>
                                    <g:set var="subcollections" value="${command.listSubCollections()}"/>
                                    <g:each var="sub" in="${subcollections}" status="i">
                                      <tr>
                                        <td valign="top"><g:textField name="name_${i}" value="${sub.name.encodeAsHTML()}" class="form-control" /></td>
                                        <td valign="top"><g:textField name="description_${i}" value="${sub.description.encodeAsHTML()}" class="form-control" /></td>
                                      </tr>
                                    </g:each>
                                    <g:set var="j" value="${subcollections.size()}"/>
                                    <g:each var="i" in="${[j, j+1, j+2]}">
                                      <tr>
                                        <td valign="top"><g:textField name="name_${i}" value="" class="form-control" /></td>
                                        <td valign="top"><g:textField name="description_${i}" value="" class="form-control"/></td>
                                      </tr>
                                    </g:each>
                                  </table>
                              </div>
                              <cl:helpText code="scope.subCollections"/>
                              </td>
                            </div>
                        <cl:helpTD/>

                    </tr>
                    </tbody>
                </table>

                <div class="buttons">
                    <span class="button"><input type="submit" class="btn btn-default" name="_action_updateDescription" value="${message(code:"collection.button.update")}" class="save"></span>
                    <span class="button"><input type="submit"  class="btn btn-default"name="_action_cancel" value="${message(code:"collection.button.cancel")}" class="cancel"></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
