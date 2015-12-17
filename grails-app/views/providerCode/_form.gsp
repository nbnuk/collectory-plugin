<%@ page import="au.org.ala.collectory.ProviderCode" %>



<div class="fieldcontain ${hasErrors(bean: providerCodeInstance, field: 'code', 'error')} required">
	<div class="col-md-1">
		<label for="code">
			<g:message code="providerCode.code.label" default="Code" />
			<span class="required-indicator">*</span>
		</label>
	</div>
	<div class="col-md-4">
		<g:textField name="code" maxlength="200" required="" value="${providerCodeInstance?.code}" class="form-control input-text"/>
	</div>
</div>
