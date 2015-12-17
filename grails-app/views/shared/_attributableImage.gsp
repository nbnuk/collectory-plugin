<table class="shy col-md-12">
  <g:if test="${fieldValue(bean: command, field: 'imageRef.file')}">
    <tr>
      <td colspan="2">
        <img alt="${fieldValue(bean: command, field: "imageRef.file")}"
                src="${resource(absolute: 'true', dir:'data/'+directory, file:command.imageRef.file)}" />
      </td>
    </tr>
    <tr>
      <td colspan="2" style="padding-bottom:14px;"><span style="padding-right:75px;">${command.imageRef.file}</span></td>
    </tr>
  </g:if>
  <tr class='prop form-group'>
    <td valign="top" class="name col-md-4">
      <g:if test="${fieldValue(bean: command, field: 'imageRef.file')}">
        <g:message code="shared.mes01" /> <br/><g:message code="shared.mes02" />
      </g:if>
      <g:else>
        <g:message code="shared.mes03" /> <br/><g:message code="shared.mes04" />
      </g:else>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.file', 'errors')} col-md-8">
      <input type="file" name="imageFile" value="${command?.imageRef?.file} class="form-control"/>
    </td>
  </tr>
  <tr class='prop form-group'>
    <td valign="top" class="name col-md-4">
      <label for="imageRef.caption"><g:message code="providerGroup.imageRef.filename.label" default="Caption" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.caption', 'errors')} col-md-8">
        <g:textField name="imageRef.caption" maxlength="128" value="${command?.imageRef?.caption}" class="form-control input-text"/>
    </td>
  </tr>
  <tr class='prop form-group'>
    <td valign="top" class="name col-md-4">
      <label for="imageRef.attribution"><g:message code="providerGroup.imageRef.attribution.label" default="Attribution" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.attribution', 'errors')} col-md-8">
        <g:textField name="imageRef.attribution" maxlength="128" value="${command?.imageRef?.attribution}"class="form-control input-text"/>
    </td>
  </tr>
  <tr class='prop form-group'>
    <td valign="top" class="name col-md-4">
      <label for="imageRef.copyright"><g:message code="providerGroup.imageRef.copyright.label" default="Copyright" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.copyright', 'errors')} col-md-8">
        <g:textField name="imageRef.copyright" maxlength="128" value="${command?.imageRef?.copyright}" class="form-control input-text"/>
    </td>
  </tr>
</table>
