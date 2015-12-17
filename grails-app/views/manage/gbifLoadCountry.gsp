<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.skin.layout}" />
    <title><g:message code="manage.gbiflc.title" /></title>
</head>
<body>
<h1><g:message code="manage.gbiflc.title01" /></h1>
<div id="baseForm">
    <g:form action="loadAllGbifForCountry" controller="manage">
            <div class="col-md-6">
                    <table class="col-md-12">
                        <tr class="prop form-group">
                            <td valign="top" class="name"><label for="country"><g:message code="manage.gbiflc.label01" />:</label></td>
                            <td valign="top" class="value col-md-6">
                                <g:select name="country" from="${pubMap.entrySet()}" optionKey="key" optionValue="value" class="form-control input-text"/>
                            </td>
                        </tr>
                        <tr class="prop form-group">
                            <td valign="top" class="name"><label for="gbifUsername"><g:message code="manage.gbiflc.label02" />:</label></td>
                            <td valign="top" class="value col-md-6"><g:field type="text" name="gbifUsername" required="true" value="" class="form-control input-text"/></td>
                        </tr>
                        <tr class="prop form-group">
                            <td valign="top" class="name"><label for="gbifPassword"><g:message code="manage.gbiflc.label03" />:</label> </td>
                            <td valign="top" class="value col-md-6"><g:field type="password" name="gbifPassword" required="true" value="" class="form-control input-text"/></td>
                        </tr>
                        <tr class="prop form-group">
                            <td valign="top" class="name"><label for="maxResources"><g:message code="manage.gbiflc.label04" />:</label></td>
                            <td valign="top" class="value col-md-6"><g:field type="number" name="maxResources"  value="1" class="form-control input-text"/></td>
                        </tr>
                        <tr class="prop form-group ">

                                <td valign="top" class="name col-md-4">

                                    <label class="checkbox">
                                        <input type="checkbox" name="reloadExistingResources" > Reload existing resources
                                    </label>
                                </td>
                        </tr>
                    </table>

                <span class="button"><input type="submit" name="performGBIFLoad" value="Load" class="save btn btn-default"></span>
            </div>

            <div class="well pull-right col-md-5">
                <p>
                    <g:message code="manage.gbiflc.des01" />.<br/>
                    <g:message code="manage.gbiflc.des02" />.
                    <br/>
                    <g:message code="manage.gbiflc.des03" />
                    <a href="http://www.gbif.org/user/register"><g:message code="manage.gbiflc.link01" /></a>.
                </p>
                <p>
                    <b><g:message code="manage.gbiflc.des04" /></b>: <g:message code="manage.gbiflc.des05" />.<br/>
                    <g:message code="manage.gbiflc.des06" />.
                </p>
            </div>
        </div>

    </g:form>
</div>

</body>
</html>