<p:library  xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:dxfs="https://www.daliboris.cz/ns/xproc/file-system"
 xmlns:fs="https://www.daliboris.cz/ns/file-system"
 xmlns:c="http://www.w3.org/ns/xproc-step"
 version="3.0">
 
 <p:documentation>
  <xhtml:section>
   <xhtml:h2>Files and file system</xhtml:h2>
   <xhtml:p>Library for processing files and getting information about files and documents.</xhtml:p>
  </xhtml:section>
 </p:documentation>
 
 <p:declare-step type="dxfs:document-file-info" name="document-file-info">
  <p:documentation>
   <xhtml:section>
    <xhtml:p>Gets fult path, parent directory path and name of the file and detailed information about the file itself, in particular its name, extension, full name (name including extension) and content type.</xhtml:p>
    <xhtml:p>To get metadat from the result, use similar step:</xhtml:p>
    <xhtml:code>
     &lt;dxfs:document-file-info name="info" /&gt;
     &lt;p:variable name="name" select="/fs:file/@name" pipe="report@info" /&gt; 
    </xhtml:code>
    
    <xhtml:p>On the result port of the step is the same document like on the input source port.</xhtml:p>
   </xhtml:section>
  </p:documentation>
  
  <p:input port="source" primary="true" />
  <p:output port="result" pipe="source@document-file-info" primary="true" />
  <p:output port="report" serialization="map{'indent' : true()}" content-types="application/xml" pipe="result@info" />
  
  <p:variable name="full-path" select="base-uri(/)" />
  <p:variable name="name" select="tokenize($full-path, '/')[last()]" />
  <p:variable name="parent-directory-path" select="substring-before($full-path, $name)" />
  <p:variable name="parent-directory-name" select="tokenize($parent-directory-path, '/')[last() - 1]" />
  <p:variable name="extension" select="if(contains($name, '.')) then '.' || tokenize($name, '\.')[.][last()] else ''" />
  <p:variable name="stem" select="if(contains($name, '.')) then substring-before($name, $extension) else $name" />
  <p:variable name="content-type" select="p:document-property(/, 'content-type')"/>
  
  <p:identity name="info">
   <p:with-input>
    <p:inline  exclude-inline-prefixes="#all">
     <fs:file full-path="{$full-path}" parent-directory-path="{$parent-directory-path}" parent-directory-name="{$parent-directory-name}" name="{$name}" stem="{$stem}" extension="{$extension}" content-type="{$content-type}" /> 
    </p:inline>
   </p:with-input>
  </p:identity>
   
 </p:declare-step>
 
 <p:declare-step type="dxfs:remove-diacritics">
  <p:input port="source" primary="true" />
  <p:output port="result" primary="true" />
  <p:option name="part" as="xs:string" values="('name', 'directory', 'all')" select="'name'" />

  <p:xslt>
   <p:with-input port="stylesheet" href="../xslt/remove-diacritics.xsl" />
  </p:xslt>
  
 </p:declare-step>

 <p:declare-step type="dxfs:file-details">
  <p:input port="source" primary="true" />
  <p:output port="result" primary="true" />
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../xslt/fs-add-file-details.xsl" />
  </p:xslt>
  
  <p:set-properties properties="map{ 'file-details': true() }" merge="true" />
  
 </p:declare-step>

 <p:declare-step type="dxfs:rename">
  <p:input port="source" primary="true" />
  <p:output port="result" primary="true" />
  <p:viewport match="c:file[@new-full-path]" name="files-loop">
   <p:identity name="file" />
   <p:variable name="new-name" select="/*/@new-name" />
   <p:file-move href="{/*/@full-path}" target="{/*/@new-full-path}" fail-on-error="false" />
   <p:choose>
    <p:when test="/c:error">
     <p:insert match="/*" position="first-child">
      <p:with-input port="source" pipe="result@file" />
      <p:with-input port="insertion" select="/*" pipe="result" />
     </p:insert>
    </p:when>
    <p:when test="/c:result">
     <p:identity>
      <p:with-input port="source" pipe="result@file" />
     </p:identity>
     <p:rename match="@name" new-name="old-name" />
     <p:rename match="@full-path" new-name="old-full-path" />
     <p:rename match="@stem" new-name="old-stem" />
     <p:rename match="@new-name" new-name="name" />
     <p:rename match="@new-full-path" new-name="full-path" />
     <p:rename match="@new-stem" new-name="stem" />
     <p:add-attribute attribute-name="xml:base" attribute-value="{$new-name}" />
    </p:when>
   </p:choose>
  </p:viewport>
 </p:declare-step>

</p:library>