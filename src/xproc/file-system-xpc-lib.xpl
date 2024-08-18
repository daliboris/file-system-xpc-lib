<p:library  xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:dxfs="https://www.daliboris.cz/ns/xproc/file-system"
 xmlns:fs="https://www.daliboris.cz/ns/file-system"
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

 <p:declare-step type="dxfs:file-details">
   <p:input port="source" primary="true" />
  <p:output port="result" primary="true" />
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../xslt/fs-add-file-details.xsl" />
  </p:xslt>
  
  <p:set-properties properties="map{ 'file-details': true() }" merge="true" />
  
 </p:declare-step>
</p:library>