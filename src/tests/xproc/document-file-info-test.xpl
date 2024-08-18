<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:dxfs="https://www.daliboris.cz/ns/xproc/file-system" 
 xmlns:fs="https://www.daliboris.cz/ns/file-system"
 xmlns:fst="https://www.daliboris.cz/ns/file-system/tests"
 xmlns:c="http://www.w3.org/ns/xproc-step"
 version="3.0">

 <p:import href="../../xproc/file-system-xpc-lib.xpl"/>

 <p:output port="result" serialization="map{'indent' : true()}" sequence="true"/>

 <p:declare-step type="fst:simple-file">
  <p:input port="source" href="../xproc/document-file-info-test.xpl"/>
  <p:output port="result" serialization="map{'indent' : true()}"/>
  
  <dxfs:document-file-info name="info" />
  <p:variable name="name" select="/fs:file/@name" pipe="report@info" />
  
  <p:identity message="Name (without extension) of the file: {$name}">
   <p:with-input port="source" pipe="report@info" />
  </p:identity>
 </p:declare-step>

 <p:declare-step type="fst:multiple-dots">
  <p:input port="source" href="../input/Morais.DLP.1-A-0017-2columns.docx"/>
  <p:output port="result" serialization="map{'indent' : true()}"/>
  
  <dxfs:document-file-info name="info" />
  <p:identity>
   <p:with-input port="source" pipe="report@info" />
  </p:identity>
  
 </p:declare-step>
 
 <p:declare-step type="fst:without-extension">
  <p:input port="source" href="../input/without-extenstion"/>
  <p:output port="result" serialization="map{'indent' : true()}"/>
  
  <dxfs:document-file-info name="info" />
  <p:identity>
   <p:with-input port="source" pipe="report@info" />
  </p:identity>
  
 </p:declare-step>
 
 <p:declare-step type="fst:for-each">
  <p:input port="source" sequence="true">
   <p:document href="../input/without-extenstion" />
   <p:document href="../xproc/document-file-info-test.xpl" />
   <p:document href="../input/Morais.DLP.1-A-0017-2columns.docx" />
  </p:input>
  <p:output port="result" serialization="map{'indent' : true()}"/>
  
  <p:for-each>
   <dxfs:document-file-info name="info" />
   <p:identity>
    <p:with-input port="source" pipe="report@info" />
   </p:identity>
  </p:for-each>
  
  <p:wrap-sequence wrapper="c:result" />
  
 </p:declare-step>
 
 
<!-- <fst:simple-file />-->
<!-- <fst:multiple-dots />-->
<!-- <fst:without-extension />-->
 <fst:for-each />
 
</p:declare-step>
