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
            <g:link class="returnAction" controller="dataProvider" action='manageAccess' params="${[id: instance.id, accessType: accessType]}">Return to managing access for ${instance.name}</g:link>
        </li>
    </ul>
</div>

<h1>Specify resources

for
${contact.email}
</h1>

<p>
    Select the dataset from the dropdown and then check all the species that the user should be given access to. <br/>
    Note: only species that contain high-resolution records for the selected dataset are enabled.
</p>

<div class="well">
    <g:form controller="dataProvider" action="updateSpecifiedAccess" params="${[id: instance.id, accessType: accessType]}" elementId="specifyForm">

        <div class="form-check">
            <select class="specifyDropdownItem" id="select-dropdown-item" name="select-dropdown-item">
                <option value="">Select a dataset with high resolution data</option>
                <g:each in="${relevantDatasets.sort {it.dataset} }" var="relevantDatasetItem">
                    <option value="${relevantDatasetItem.dr_uid}">${relevantDatasetItem.dataset}: ${relevantDatasetItem.dr_uid} (${relevantDatasetItem.records} records)</option>
                </g:each>
            </select>
        </div>

        <hr/>

        <input type="hidden" name="userId" value="${contact.userId}"/>
        <input type="hidden" name="dataResourceTaxa" id="dataResourceTaxa" value='${approvedAccessDataResourceTaxa_unencoded}'/>
        <table>
            <tr>
                <td><b>Species</b></td>
                <td><b>No. of high resolution records</b></td>
            </tr>
            <g:each in="${relevantSpecies.sort {it.taxon} }" var="species">
                <tr>
                    <td>
                        <div class="form-check">
                            <input class="form-check-input specifyTaxon"
                                   type="checkbox"
                                   id="${species.lsid}"
                                   name="approvedUIDs"
                                   value="${species.lsid}"
                                   disabled="true"
                            >
                            <label class="form-check-label" for="${species.lsid}" id="label_${species.lsid}">
                                ${species.taxon + (species.commonname? ": " + species.commonname : "")}
                            </label>
                        </div>
                    </td>
                    <td>
                        <span id="${species.lsid}_recs" class="species_recs" style="margin-left:10px">-</span>
                    </td>
                </tr>
            </g:each>
        </table>
        <button type="submit" class="btn btn-primary">Save all changes</button>
        <g:link class="returnAction" controller="dataProvider" action="manageAccess" params="${[id: instance.id, accessType: accessType]}">
            <input type="button" class="btn btn-default" value="Cancel">
        </g:link>

    </g:form>
</div>

<div class="well">
    <p>Datasets with high resolution records that the user has been granted access to:</p>
    <div id="user-dataset-list">

    </div>
</div>

<script type="text/javascript">

    var previousDataset = '';
    var approvedAccessDataResourceTaxa = JSON.parse('${approvedAccessDataResourceTaxa_unencoded}');
    var relevantDatasetsSortedDruid = [];
    var relevantDatasetsSortedName = [];
    <g:each in="${relevantDatasets.sort {it.dataset} }" var="relevantDatasetItem">
    relevantDatasetsSortedDruid.push("${relevantDatasetItem.dr_uid}");
    relevantDatasetsSortedName.push("${relevantDatasetItem.dataset} - ${relevantDatasetItem.dr_uid}");
    </g:each>


    $( document ).ready(function() {
        $('#allResources').change(function () {
            if (this.checked) {
                $('.specifyTaxon').attr("disabled", true);
            } else {
                $('.specifyTaxon').removeAttr("disabled");
            }
        });

        $('#specifyForm').on('submit', function(e) {
            if (previousDataset != '') {
                e.preventDefault();
                setSpeciesApproved(previousDataset);
                this.submit();
            }
        });

        $('#select-dropdown-item').on('focus', function () {
            previousDataset = this.value;
        });

        $('#select-dropdown-item').change(function () {
            if (previousDataset != '') {
                setSpeciesApproved(previousDataset);
            }
            var sp_checked = getSpeciesApproved(this.value);

            recSummary(this.value, '${instance.uid}', sp_checked);
            setUserDatasetList();
            previousDataset = this.value;
        });

        setUserDatasetList();
    });

    function recSummary(druid, uid, sp_checked) {

        var getRecSummary = "${g.createLink(controller: 'dataProvider', action: 'speciesHighResRecordsForDataset')}";

        getRecSummary += "?druid=" + druid;
        $.getJSON(getRecSummary, function(data){
            $(".species_recs").html('');
            $(".specifyTaxon").attr("disabled", true);

            $(".form-check").closest("tr").hide();
            //$(".form-check-label").hide();

            $(".specifyTaxon").removeAttr("checked");
            $(".form-check-label").css("color", "#999999");
            for( var i = 0; i < sp_checked.length; i++) {
                $("#" + sp_checked[i]).attr("checked", true);
            }
            $.each(data, function(index, returnedResult) {
                console.log('in recSummary');
                console.log(returnedResult);
                var sp_lsid = returnedResult.lsid.toString().replace(/"/g,"");
                $("#" + sp_lsid).removeAttr("disabled");
                $("#" + sp_lsid).closest("tr").show();
                $("#" + sp_lsid + "_recs").html(returnedResult.records);
                $("#label_" + sp_lsid).css("color","black");
            });

        });
    }

    function getSpeciesApproved(uid) {
        var sp_approved = [];
        var sp_list_for_dataset = approvedAccessDataResourceTaxa.filter(
            function(data){ return data.data_resource_uid == uid }
        );
        if (sp_list_for_dataset.length !== 0) {
            $.each(sp_list_for_dataset[0].lsid, function (i, sp) {
                sp_approved.push(sp);
            });
        }
        return sp_approved;
    }

    function setSpeciesApproved(uid) {
        var sp_approved = [];
        $(".specifyTaxon").each(function( index ) {
            if (this.checked) sp_approved.push(this.id);
        });
        console.log("in setSpeciesApproved, new approval species = ");
        console.log(sp_approved);

        //strip out the existing element, if it exists
        var sp_list_for_dataset = approvedAccessDataResourceTaxa.filter(
            function(data){ return data.data_resource_uid != uid }
        );
        approvedAccessDataResourceTaxa = sp_list_for_dataset;
        if (sp_approved.length > 0) {
            //new dataset is being approved
            approvedAccessDataResourceTaxa.push(
                {lsid: sp_approved, data_resource_uid: uid}
            );
        }
        $("#dataResourceTaxa").val(JSON.stringify(approvedAccessDataResourceTaxa));
        //console.log(JSON.stringify(approvedAccessDataResourceTaxa));
    }

    function setUserDatasetList() {
        $("#user-dataset-list").html('');
        console.log('in setUserDatasetList');
        console.log(relevantDatasetsSortedDruid);
        console.log(approvedAccessDataResourceTaxa);
        $.each(relevantDatasetsSortedDruid, function(index, druid) {
            var in_list = approvedAccessDataResourceTaxa.filter(
                function(data){ return data.data_resource_uid == druid }
            );
            console.log(in_list);
            if (in_list.length !== 0) {
                var ds_name = relevantDatasetsSortedName[index];
                var sppNames = "";
                $.each(in_list, function(idx, datasets) {
                    $.each(datasets.lsid, function (index, spp) {
                        sppNames += (index + idx > 0 ? '<br/>' : '') + $("#label_" + spp).text();
                    });
                });
                $("#user-dataset-list").append(ds_name + ": <div style='margin-left:10em'>" + sppNames + "</div><br/>");
            }
        });
    }

</script>
</body>




</html>
