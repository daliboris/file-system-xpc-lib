<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:c="http://www.w3.org/ns/xproc-step"
 xmlns:sf="https://www.daliboris.cz/ns/xslt/string/functions"
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Aug 26, 2024</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:param name="part" select="'name'" as="xs:string" />
 
 <xsl:mode on-no-match="shallow-copy"/>
 
 <xsl:template match="c:directory">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:if test="$part = ('directory', 'all')">
    <xsl:for-each select="@*[contains(local-name(), 'directory')]">
     <xsl:attribute name="new-{local-name()}" select="sf:remove-diacritics(.)" />
    </xsl:for-each>
   </xsl:if>
   <xsl:apply-templates />
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="c:file">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:if test="$part = ('name', 'all')">
    <xsl:variable name="value" select="@name"/>
    <xsl:variable name="new-value" select="sf:remove-diacritics($value)" />
    <xsl:if test="$value ! $new-value">
     <xsl:apply-templates select="@name | @stem | @full-path" mode="new-value" />
    </xsl:if>
   </xsl:if>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="@full-path" mode="new-value">
  <xsl:choose>
   <xsl:when test="$part = ('all')">
    <xsl:variable name="new-value" select="sf:remove-diacritics(.)" />
    <xsl:if test=". != $new-value">
     <xsl:attribute name="new-{local-name()}" select="$new-value" />     
    </xsl:if>
   </xsl:when>
   <xsl:when test="$part = ('directory', 'name')">
    <xsl:variable name="tokens" select="tokenize(., '/')[.]"/>
    <xsl:variable name="name" select="$tokens[last()]"/>
    <xsl:variable name="directory" select="string-join($tokens[position() lt last()], '/')"/>
    
    <xsl:if test="$part = 'directory'">
     <xsl:variable name="new-value" select="sf:remove-diacritics($directory)" />
     <xsl:if test="$directory != $new-value">
      <xsl:attribute name="new-{local-name()}" select="concat($new-value, '/', $name)" />     
     </xsl:if>     
    </xsl:if>
    <xsl:if test="$part = 'name'">
     <xsl:variable name="new-value" select="sf:remove-diacritics($name)" />
     <xsl:if test="$name != $new-value">
      <xsl:attribute name="new-{local-name()}" select="concat($directory, '/', $new-value)" />     
     </xsl:if>     
    </xsl:if>
   </xsl:when>
  </xsl:choose>
 </xsl:template>
 
 <xsl:template match="@name | @stem" mode="new-value">
  <xsl:copy-of select="." />
  <xsl:if test="$part = ('name', 'all')">
   <xsl:variable name="new-value" select="sf:remove-diacritics(.)" />
   <xsl:if test=". != $new-value">
    <xsl:attribute name="new-{local-name()}" select="$new-value" />     
   </xsl:if>
  </xsl:if>  
 </xsl:template>
 
 <xsl:function name="sf:remove-diacritics" as="xs:string?">
  <xsl:param name="text" as="xs:string?" />
  <xsl:value-of select="normalize-unicode($text, 'NFKD') => replace('\p{IsCombiningDiacriticalMarks}', '')"/>
 </xsl:function>
 
</xsl:stylesheet>