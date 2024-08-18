<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxfs="https://www.daliboris.cz/ns/xproc/file-system" 
	xmlns:fs="https://www.daliboris.cz/ns/file-system"
	xmlns:fst="https://www.daliboris.cz/ns/file-system/tests"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0">
	
	<p:import href="../../xproc/file-system-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
  <p:input port="source" primary="true">
  	<p:document href="../input/directory.xml" />
  </p:input>
   
	<p:output port="result" primary="true" />
	
	<p:option name="debug-path" select="()" as="xs:string?" />
	
	<dxfs:file-details />

	<p:variable name="file-details-property" select="p:document-property(/, 'file-details')" />
	
	<p:identity message="Is file-details-property true: {$file-details-property eq true()}" />
	
	<p:store href="../output/directory.xml" serialization="map{'indent' : true()}" message="Storing result to ../output/directory.xml" />

	

</p:declare-step>
