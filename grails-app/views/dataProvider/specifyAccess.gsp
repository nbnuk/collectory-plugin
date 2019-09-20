<%@ page import="au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <g:set var="entityName" value="${instance.ENTITY_TYPE}" />
        <g:set var="entityNameLower" value="${cl.controller(type: instance.ENTITY_TYPE)}"/>
        <g:set var="approvedAccessDataResourceTaxa_unencoded" value='${approvedAccessDataResourceTaxa.encodeAsRaw()}'/>
        <title>${instance.name} | <g:message code="default.show.label" args="[entityName]" /></title>
    </head>
<body>

<div class="btn-toolbar">
    <ul class="btn-group">
        <li class="btn btn-default"><cl:homeLink/></li>
        <li class="btn btn-default">
            <g:link class="returnAction" controller="dataProvider" action='manageAccess' id="${instance.id}">Return to managing access for ${instance.name}</g:link>
        </li>
    </ul>
</div>

<h1>Specify resources

    for
    ${contact.email}
</h1>

<p>
    Select the species from the dropdown and then check all the datasets that the user should be given access to. <br/>
    Note: only datasets that contain records for the selected species are enabled.
</p>

<div class="well">
    <g:form controller="dataProvider" action="updateSpecifiedAccess" id="${instance.id}" elementId="specifyForm">

        <div class="form-check">
            <select class="specifySensitiveSpecies" id="select-sensitive-species" name="select-sensitive-species">
                <option value="">Select a sensitive species</option>
                <g:each in="${sensitiveSpecies.sort {it.taxon} }" var="sensitiveSpeciesItem">
                    <option value="${sensitiveSpeciesItem.lsid}">${sensitiveSpeciesItem.taxon}: ${sensitiveSpeciesItem.commonname} (${sensitiveSpeciesItem.records} records)</option>
                </g:each>
            </select>
        </div>

        <hr/>

        <input type="hidden" name="userId" value="${contact.userId}"/>
        <input type="hidden" name="dataResourceTaxa" id="dataResourceTaxa" value='${approvedAccessDataResourceTaxa_unencoded}'/>
        <table>
            <tr>
                <td><b>Dataset</b></td>
                <td><b>No. of records</b></td>
            </tr>
        <g:each in="${instance.resources.sort {it.name} }" var="dataResource">
            <tr>
                <td>
                    <div class="form-check">
                        <input class="form-check-input specifyResource"
                            type="checkbox"
                            id="${dataResource.uid}"
                            name="approvedUIDs"
                            value="${dataResource.uid}"
                            disabled="true"
                        >
                        <label class="form-check-label" for="${dataResource.uid}" id="label_${dataResource.uid}">
                            ${dataResource.name}
                        </label>
                    </div>
                </td>
                <td>
                    <span id="${dataResource.uid}_recs" class="dataset_recs" style="margin-left:10px">-</span>
                </td>
            </tr>
        </g:each>
        </table>
        <button type="submit" class="btn btn-primary">Save all changes</button>
        <g:link class="returnAction" controller="dataProvider" action='manageAccess' id="${instance.id}">
            <input type="button" class="btn btn-default" value="Cancel">
        </g:link>

    </g:form>
</div>

<div class="well">
    <p>Sensitive species the user has been granted access to:</p>
    <div id="user-species-list">

    </div>
</div>

<script type="text/javascript">

    var previousSpecies = '';
    var approvedAccessDataResourceTaxa = JSON.parse('${approvedAccessDataResourceTaxa_unencoded}');
    var sensitiveSppSortedLsid = [];
    var sensitiveSppSortedName = [];
    <g:each in="${sensitiveSpecies.sort {it.taxon} }" var="sensitiveSpeciesItem">
        sensitiveSppSortedLsid.push("${sensitiveSpeciesItem.lsid}");
        sensitiveSppSortedName.push("${sensitiveSpeciesItem.taxon} - ${sensitiveSpeciesItem.commonname}");
    </g:each>


    $( document ).ready(function() {
        $('#allResources').change(function () {
            if (this.checked) {
                $('.specifyResource').attr("disabled", true);
            } else {
                $('.specifyResource').removeAttr("disabled");
            }
        });

        $('#specifyForm').on('submit', function(e) {
            if (previousSpecies != '') {
                e.preventDefault();
                setDatasetsApproved(previousSpecies);
                this.submit();
            }
        });

        $('#select-sensitive-species').on('focus', function () {
            previousSpecies = this.value;
        });

        $('#select-sensitive-species').change(function () {
            if (previousSpecies != '') {
                setDatasetsApproved(previousSpecies);
            }
            var ds_checked = getDatasetsApproved(this.value);
            recSummary(this.value, '${instance.uid}', ds_checked);
            setUserSpeciesList();
            previousSpecies = this.value;
        });

        setUserSpeciesList();
    });

    function recSummary(lsid, uid, ds_checked) {

        var getRecSummary = "${g.createLink(controller: 'dataProvider', action: 'speciesRecordsForDataProvider')}";
        getRecSummary += "?lsid=" + lsid + "&uid=" + uid;

        $.getJSON(getRecSummary, function(data){
            $(".dataset_recs").html('');
            $(".specifyResource").attr("disabled", true);
            $(".specifyResource").removeAttr("checked");
            $(".form-check-label").css("color", "#999999");
            for( var i = 0; i < ds_checked.length; i++) {
                $("#" + ds_checked[i]).attr("checked", true);
            }
            $.each(data, function(index, returnedResult) {
                var ds_uid = returnedResult.dr_uid.toString().replace(/"/g,"");
                $("#" + ds_uid).removeAttr("disabled");
                $("#" + ds_uid + "_recs").html(returnedResult.records);
                $("#label_" + ds_uid).css("color","black");
            });

        });
    }

    function getDatasetsApproved(lsid) {
        var dr_approved = [];
        var ds_list_for_taxon = approvedAccessDataResourceTaxa.filter(
            function(data){ return data.lsid == lsid }
        );
        if (ds_list_for_taxon.length !== 0) {
            $.each(ds_list_for_taxon[0].data_resource_uid, function (i, dr) {
                dr_approved.push(dr);
            });
        }
        return dr_approved;
    }

    function setDatasetsApproved(lsid) {
        var dr_approved = [];
        $(".specifyResource").each(function( index ) {
            if (this.checked) dr_approved.push(this.id);
        });
        //console.log("new approval datasets = " + dr_approved);

        //strip out the existing element, if it exists
        var ds_list_for_taxon = approvedAccessDataResourceTaxa.filter(
            function(data){ return data.lsid != lsid }
        );
        approvedAccessDataResourceTaxa = ds_list_for_taxon;
        if (dr_approved.length > 0) {
            //new taxon is being approved
            approvedAccessDataResourceTaxa.push(
                {lsid: lsid, data_resource_uid: dr_approved}
            );
        }
        $("#dataResourceTaxa").val(JSON.stringify(approvedAccessDataResourceTaxa));
        //console.log(JSON.stringify(approvedAccessDataResourceTaxa));
    }

    function setUserSpeciesList() {
        $("#user-species-list").html('');
        $.each(sensitiveSppSortedLsid, function(index, lsid) {
            var in_list = approvedAccessDataResourceTaxa.filter(
                function(data){ return data.lsid == lsid }
            );
            if (in_list.length !== 0) {
                var spp_name = sensitiveSppSortedName[index];
                var datasetNames = "";
                $.each(in_list, function(idx, spp) {
                    $.each(spp.data_resource_uid, function (index, druid) {
                        datasetNames += (index + idx > 0 ? '<br/>' : '') + $("#label_" + druid).text();
                    });
                });
                $("#user-species-list").append(spp_name + ": <div style='margin-left:10em'>" + datasetNames + "</div><br/>");
            }
        });
    }

</script>
</body>




</html>