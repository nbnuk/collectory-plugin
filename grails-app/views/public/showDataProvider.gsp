<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <meta name="breadcrumbParent"
          content="${createLink(action: 'map', controller: 'public')},${message(code: 'breadcrumb.dataproviders')}"
    />
    <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
    <script type="text/javascript" language="javascript" src="https://www.google.com/jsapi"></script>
    <r:require modules="jquery, fancybox, jquery_jsonp, jquery_ui_custom, jstree, taxonTree, datadumper, jquery_i18n, collectory, charts_plugin"/>

    <script type="text/javascript">
        // define biocache server
        biocacheServicesUrl = "${grailsApplication.config.biocacheServicesUrl}";
        biocacheWebappUrl = "${grailsApplication.config.biocacheUiURL}";
        loadLoggerStats = ${!grailsApplication.config.disableLoggerLinks.toBoolean()};
        $(document).ready(function () {
            $("a#lsid").fancybox({
                'hideOnContentClick': false,
                'titleShow': false,
                'autoDimensions': false,
                'width': 600,
                'height': 180
            });
            $("a.current").fancybox({
                'hideOnContentClick': false,
                'titleShow': false,
                'titlePosition': 'inside',
                'autoDimensions': true,
                'width': 300
            });
        });
    </script>

    <style type="text/css">
        .institutionImage { margin-bottom: 15px; }
    </style>
</head>

<body class="two-column-right">
<div id="content">
    <div id="header" class="collectory">
        <cl:pageOptionsPopup instance="${instance}"/>
        <div class="row">
            <div class="col-md-8">
                <cl:h1 value="${instance.name}"/>
                <cl:valueOrOtherwise value="${instance.acronym}"><span
                        class="acronym">Acronym: ${fieldValue(bean: instance, field: "acronym")}</span></cl:valueOrOtherwise>
                <g:if test="${instance.guid?.startsWith('urn:lsid:')}">
                    <span class="lsid"><a href="#lsidText" id="lsid" class="local"
                                          title="Life Science Identifier (pop-up)"><g:message code="public.lsid" /></a></span>

                    <div style="display:none; text-align: left;">
                        <div id="lsidText" style="text-align: left;">
                            <b><a class="external_icon" href="https://wayback.archive.org/web/20100515104710/http://lsids.sourceforge.net:80/"
                                  target="_blank"><g:message code="public.lsidtext.link" />:</a></b>

                            <p style="margin: 10px 0;"><cl:guid target="_blank"
                                                                guid='${fieldValue(bean: instance, field: "guid")}'/></p>

                            <p style="font-size: 12px;"><g:message code="public.lsidtext.des" />.</p>
                        </div>
                    </div>
                </g:if>
                <div class="section">
                <g:if test="${instance.pubDescription}">
                    <h2><g:message code="public.des" /></h2>
                    <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
                    <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
                </g:if>
                <g:if test="${instance.focus}">
                    <h2><g:message code="public.sdp.content.label02" /></h2>
                    <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>
                </g:if>
                <h2><g:message code="public.sdp.content.label03" /></h2>
                <g:set var="hasRecords" value="false"/>
                <g:if test="${instance.getResources()}">
                <ol>
                    <g:each var="c" in="${instance.getResources().sort { it.name }}">
                        <li><g:link controller="public" action="show" id="${c.uid}">${c?.name}</g:link>
                            <br/>
                            <span style="color:#555;">${c?.makeAbstract(400)}</span></li>
                        <g:if test="${c.resourceType == 'records'}">
                            <g:set var="hasRecords" value="true"/>
                        </g:if>
                    </g:each>
                </ol>
                </g:if>
                <g:else>
                    <p><g:message code="public.sdp.content.noresources"/></p>
                </g:else>

                <g:if test="${hasRecords == 'true'}">
                    <div id='usage-stats'>
                        <h2><g:message code="public.sdp.usagestats.label" /></h2>
                        <div id='usage'>
                            <p><g:message code="public.usage.des" />...</p>
                        </div>





                    </div>
                </g:if>


                <div id="charts"> </div>
                <cl:lastUpdated date="${instance.lastUpdated}"/>

            </div><!--close section-->
            </div><!--close column-one-->
            <div class="col-md-4">

                <!-- logo -->

                <g:if test="${fieldValue(bean: instance, field: 'logoRef') && fieldValue(bean: instance, field: 'logoRef.file')}">
                    <section class="public-metadata">
                    <img class="institutionImage"
                         src='${resource(absolute: "true", dir: "data/" + instance.urlForm() + "/", file: fieldValue(bean: instance, field: 'logoRef.file'))}'/>
                    </section>
                </g:if>

                <div id="dataAccessWrapper" style="display:none;">
                    <g:render template="dataAccess" model="[instance:instance]"/>
                </div>

            <section class="public-metadata">
                <h5 id="totalVerifiedRecordCount"></h5>
            </section>


            <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
                    <section class="public-metadata">
                        <img class="entityLogo" alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                             src="${resource(absolute: "true", dir: "data/" + instance.urlForm() + "/", file: instance.imageRef.file)}"/>
                        <cl:formattedText
                                pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                        <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p
                                class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                        <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p
                                class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                    </section>
                </g:if>


            <div id="dataAccessWrapper" style="display:none;">
                <g:render template="dataAccess" model="[instance:instance]"/>
            </div>

            <section class="public-metadata">
                <h4><g:message code="public.location" /></h4>
                <g:if test="${instance.address != null && !instance.address.isEmpty()}">
                    <p>
                        <cl:valueOrOtherwise
                                value="${instance.address?.street}">${instance.address?.street}<br/></cl:valueOrOtherwise>
                        <cl:valueOrOtherwise
                                value="${instance.address?.city}">${instance.address?.city}<br/></cl:valueOrOtherwise>
                        <cl:valueOrOtherwise
                                value="${instance.address?.state}">${instance.address?.state}</cl:valueOrOtherwise>
                        <cl:valueOrOtherwise
                                value="${instance.address?.postcode}">${instance.address?.postcode}<br/></cl:valueOrOtherwise>
                        <cl:valueOrOtherwise
                                value="${instance.address?.country}">${instance.address?.country}<br/></cl:valueOrOtherwise>
                    </p>
                </g:if>
                <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
                <cl:ifNotBlank value='${fieldValue(bean: instance, field: "phone")}'/>
            </section>

            <!-- contacts -->
                <g:render template="contacts" bean="${instance.getPublicContactsPrimaryFirst()}"/>

            <!-- web site -->
                <g:if test="${instance.websiteUrl}">
                    <section class="public-metadata">
                        <h4><g:message code="public.website" /></h4>

                        <div class="webSite">
                            <a class='external_icon' target="_blank"
                               href="${instance.websiteUrl}"><g:message code="public.sdp.content.link01" /></a>
                        </div>
                    </section>
                </g:if>

            <g:if test="${instance.groupClassification}">
            <section class="public-metadata">
                <h4><g:message code="groupClassification.label" /></h4>
                ${instance.groupClassification}
            </section>
            </g:if>

            <!-- network membership -->
                <g:if test="${instance.networkMembership}">
                    <section class="public-metadata">
                        <h4><g:message code="public.network.membership.label" /></h4>
                        <g:if test="${instance.isMemberOf('CHAEC')}">
                            <p><g:message code="public.network.membership.des01" /></p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "butflyyl.gif")}"/>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHAH')}">
                            <p><g:message code="public.network.membership.des02" /></p>
                            <a target="_blank" href="http://www.chah.gov.au"><img
                                    src="${resource(absolute: "true", dir: "data/network/", file: "CHAH_logo_col_70px_white.gif")}"/>
                            </a>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHAFC')}">
                            <p><g:message code="public.network.membership.des03" /></p>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHACM')}">
                            <p><g:message code="public.network.membership.des04" /></p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "chacm.png")}"/>
                        </g:if>
                        <g:if test="${instance.isMemberOf('NBN')}">
                            <p><g:message code="public.network.membership.des05" /></p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "nbn.png")}"/>
                        </g:if>
                    </section>
                </g:if>

                <g:if test="${viewerIsAdmin}">
                    <span><g:link class="btn btn-default" controller="dataProvider" action='show' id="${instance.id}">Admin</g:link></span>
                </g:if>

            <!-- external identifiers -->
                <g:render template="externalIdentifiers" model="[instance:instance]"/>

        </div>
        </div><!--close column-two-->
    </div>
</div><!--close content-->



<script type="text/javascript">
    /************************************************************\
     *
     \************************************************************/
    function onLoadCallback() {

        var CHARTS_CONFIG = {
            biocacheServicesUrl: "${grailsApplication.config.biocacheServicesUrl}",
            biocacheWebappUrl: "${grailsApplication.config.biocacheUiURL}",
            collectionsUrl: "${grailsApplication.config.grails.serverURL}"
        };

        // records
        var queryUrl = CHARTS_CONFIG.biocacheServicesUrl + "/occurrences/search.json?pageSize=0&q=data_provider_uid:${instance.uid}";
        $.ajax({
            url: queryUrl,
            dataType: 'jsonp',
            timeout: 30000,
            complete: function (jqXHR, textStatus) {
                if (textStatus == 'timeout') {
                    noData();
                    alert('Sorry - the request was taking too long so it has been cancelled.');
                }
                if (textStatus == 'error') {
                    noData();
                    alert('Sorry - the records breakdowns are not available due to an error.');
                }
            },
            success: function (data) {
                // check for errors
                if (data.length == 0 || data.totalRecords == undefined || data.totalRecords == 0) {
                    noData();
                } else {
                    setNumbers(data.totalRecords);
                    if (data.totalRecords > 0) {
                        $('#dataAccessWrapper').css({display: 'block'});
                        $('#totalRecordCountLink').html(data.totalRecords.toLocaleString() + " ${g.message(code: 'public.show.rt.des03')}");
                    }
                }
            }
        });

        <g:if test="${grailsApplication.config.verifiedRecordsToCount}">
        // verification status: count verified records
        var facetVerified = "${grailsApplication.config.verifiedRecordsToCount}";
        var queryUrlVerifiedRecs = CHARTS_CONFIG.biocacheServicesUrl + "/occurrences/search.json?pageSize=0&q=data_provider_uid:${instance.uid}";
        showVerifiedRecordCount(queryUrlVerifiedRecs, facetVerified, "${g.message(code: 'public.show.rt.des08')}");
        </g:if>

        // stats
        if (loadLoggerStats) {
            loadDownloadStats("${grailsApplication.config.loggerURL}", "${instance.uid}", "${instance.name}", "1002");
        }
    }

    /************************************************************\
     *
     \************************************************************/

    google.load("visualization", "1", {packages: ["corechart"]});
    google.setOnLoadCallback(onLoadCallback);
</script>

<g:render template="taxonTree" model="[facet:'data_provider_uid', instance: instance]" />
<g:render template="charts" model="[facet:'data_provider_uid', instance: instance]" />

</body>
</html>