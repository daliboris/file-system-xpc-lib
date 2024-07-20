<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:dlfs="https://www.daliboris.cz/ns/xproc/file-system" 
 xmlns:fs="https://www.daliboris.cz/ns/file-system" version="3.0">

 <p:import href="../../xproc/file-system-xpc-lib.xpl"/>

 <p:output port="result" serialization="map{'indent' : true()}"/>
 <p:input port="source" href="../xproc/document-file-info-test.xpl"/>


 <dlfs:document-file-info name="info" />
 <p:variable name="name" select="/fs:file/@name" pipe="report@info" />
  
 <p:identity message="Name (without extension) of the file: {$name}">
  <p:with-input port="source" pipe="report@info" />
 </p:identity>
 

</p:declare-step>
