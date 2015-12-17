<%@ page import="au.org.ala.collectory.DataResource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <title><g:message code="dataResource.base.label" default="Edit data resource metadata" /></title>
        <style type="text/css">
            li.free :hover { cursor: pointer; }
            li.free { cursor: pointer; }
        </style>
    </head>
    <body>
        <div class="nav">
        <h1><g:message code="collection.title.editing" />: ${command.name}</h1>
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
            <g:form method="post" name="baseForm" action="base">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <div class="dialog">
                    <table class="col-md-12">
                        <tbody>

                        <!-- public description -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <label for="pubDescription"><g:message code="providerGroup.pubDescription.label" default="Public Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'pubDescription', 'errors')} col-md-10">
                                <g:textArea name="pubDescription" class="form-control"  rows="${cl.textAreaHeight(text:command.pubDescription)}" value="${command.pubDescription}" />
                                <cl:helpText code="providerGroup.pubDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- tech description -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <label for="techDescription"><g:message code="providerGroup.techDescription.label" default="Technical Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'techDescription', 'errors')} col-md-10">
                                <g:textArea name="techDescription" class="form-control"  rows="${cl.textAreaHeight(text:command.techDescription)}" value="${command?.techDescription}" />
                                <cl:helpText code="providerGroup.techDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- focus -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <label for="focus"><g:message code="providerGroup.focus.label" default="Focus" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'focus', 'errors')} col-md-10">
                                <g:textArea name="focus" class="form-control"  rows="${cl.textAreaHeight(text:command.focus)}" value="${command?.focus}" />
                                <cl:helpText code="providerGroup.focus"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- data generalisations -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <label for="dataGeneralizations"><g:message code="dataResource.dataGeneralizations.label" default="Data Generalisations" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'dataGeneralizations', 'errors')} col-md-10">
                                <g:textArea name="dataGeneralizations" class="form-control" rows="${cl.textAreaHeight(text:command.dataGeneralizations)}" value="${command?.dataGeneralizations}" />
                                <cl:helpText code="dataResource.dataGeneralizations"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- information withheld -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <label for="informationWithheld"><g:message code="dataResource.informationWithheld.label" default="Information withheld" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'informationWithheld', 'errors')} col-md-10">
                                <g:textArea name="informationWithheld" class="form-control" rows="${cl.textAreaHeight(text:command.informationWithheld)}" value="${command?.informationWithheld}" />
                                <cl:helpText code="dataResource.informationWithheld"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- content types -->
                        <tr class="prop form-group">
                            <td valign="top" class="name col-md-2">
                              <g:message code="dataResource.contentTypes.label" default="Content types" />
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'contentTypes', 'errors')} col-md-10">
                                <g:hiddenField name="contentTypes" value="${command.contentTypes}"/>
                                <p><g:message code="dataresource.description.des01" />.
                                <cl:helpText code="dataResource.informationWithheld"/>
                                </p>

                                <div class="row">
                                    <div class="source-box col-md-6">
                                        <h4><g:message code="dataresource.description.title01" /></h4>
                                        <ul>
                                            <g:each var="ct" in="${DataResource.contentTypesList}">
                                                <li class='free'>${ct}</li>
                                            </g:each>
                                        </ul>
                                    </div>
                                    <div class="sink-box col-md-6 well well-small">
                                        <h4><g:message code="dataresource.description.title02" /></h4>
                                        <ul>
                                            <li class="msg"><g:message code="dataresource.description.des02" />.</li>
                                        </ul>
                                    </div>
                                </div>
                              </td>
                              <cl:helpTD/>
                        </tr>

                      </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateDescription" value="${message(code:"collection.button.update")}" class="save btn btn-default"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="${message(code:"collection.button.cancel")}" class="cancel btn btn-default"></span>
                </div>
            </g:form>
        </div>

        <script type="text/javascript">
            $(function() {
                // bind click
                $('li.free').click(function() {
                    if ($(this).parent().parent().hasClass('source-box')) {
                        add(this);
                    }
                    else {
                        remove(this);
                    }
                });
                // move selected types to sink
                var selected = getSelectedList();
                $('li.free').each(function(index, element) {
                    $.each(selected, function(index, value) {
                        if ($(element).html() == value) {
                            add(element);
                        }
                    });
                })
            });
            function add(obj) {
                // clear instructions if present
                $('.sink-box li.msg').remove();
                $(obj).appendTo($('.sink-box ul'));
                addToList($(obj).html());
            }
            function remove(obj) {
                $(obj).appendTo($('.source-box ul'));
                removeFromList($(obj).html());
            }
            function getSelectedList() {
                var list = $.parseJSON($('input#contentTypes').val());
                return list == undefined ? [] : list
            }
            function addToList(ct) {
                var list = getSelectedList();
                if ($.inArray(ct, list) < 0) {
                    list.push(ct);
                }
                $('input#contentTypes').val(toJSON(list));
            }
            function removeFromList(ct) {
                var list = getSelectedList();
                var idx = $.inArray(ct, list);
                list.splice(idx,1);
                $('input#contentTypes').val(toJSON(list));
            }
            function toJSON(list) {
                if (typeof(JSON) == 'object' && JSON.stringify) {
                    return JSON.stringify(list);
                }
                else {
                    // assume list of string
                    if (list.length == 0) return "";
                    var str = "[";
                    $.each(list, function(index, value) {
                        str += '"' + value + '",';
                    })
                    str = (str.length > 1 ? str.substr(0,str.length-1) : str) + "]";
                    return str;
                }
            }
        </script>
    </body>
</html>
