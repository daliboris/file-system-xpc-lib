<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:c="http://www.w3.org/ns/xproc-step"
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Aug 12, 2024</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:mode on-no-match="shallow-copy" />
 
 <xsl:template match="c:directory">
  <xsl:param name="parent" as="xs:string?" />
  <xsl:variable name="parent-directory-name" select="if(empty($parent)) then tokenize(@xml:base, '/')[.][last() - 1] else parent::c:directory/@name" /> <!-- tokenize($parent-directory-path, '/')[last() - 1] -->
  <xsl:variable name="parent-directory-path" select="if(empty($parent)) then substring-before(@xml:base, @name) else $parent" />
  

  <xsl:variable name="full-path" select="if(empty($parent)) then @xml:base else concat($parent, @xml:base)"/>
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:attribute name="full-path" select="$full-path" />
   <xsl:attribute name="parent-directory-path" select="$parent-directory-path" />
   <xsl:attribute name="parent-directory-name" select="$parent-directory-name" />
   <xsl:apply-templates>
    <xsl:with-param name="parent" select="$full-path" />
   </xsl:apply-templates>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="c:file">
  <xsl:param name="parent" as="xs:string?" />
  <xsl:variable name="extension" select="if(contains(@name, '.')) then '.' || tokenize(@name, '\.')[.][last()] else ''" />
  <xsl:variable name="stem" select="if(contains(@name, '.')) then substring-before(@name, $extension) else @name" />
  <xsl:variable name="full-path" select="if(empty($parent)) then @xml:base else concat($parent, @xml:base)"/>
  <xsl:variable name="parent-directory-path" select="$parent" />
  <xsl:variable name="parent-directory-name" select="parent::c:directory/@name" /> <!-- tokenize($parent-directory-path, '/')[last() - 1] -->
  
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:attribute name="full-path" select="$full-path" />
   <xsl:attribute name="extension" select="$extension" />
   <xsl:attribute name="stem" select="$stem" />
   <xsl:attribute name="parent-directory-path" select="$parent-directory-path" />
   <xsl:attribute name="parent-directory-name" select="$parent-directory-name" />
  </xsl:copy>
 </xsl:template>
 
</xsl:stylesheet>