<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:hub="http://www.le-tex.de/namespace/hub"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs cx css hub"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  version="2.0">
  
  <!-- this template expects a flat or evolved hub document and converts it to docbook 5.0 -->
  
  <!-- remove hub xml-model -->
  <xsl:template match="//processing-instruction()" priority="100"/>
    
  
  <!-- remove whitespace before root element-->
  <xsl:template match="/text()"/> 
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="/hub">
    <!-- xml-models for Docbook 5.0 -->
    <xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
    <xsl:processing-instruction name="xml-model">href="http://www.le-tex.de/resource/schema/hub/1.1/hub.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
    <!-- rename hub to book element, drop atts except @xml:base -->
    <book version="5.0">
      <xsl:apply-templates select="@xml:base"/>
      <!-- make first section title to book title if only one top-level section exists -->
      <xsl:if test="section[1 and last()]">
        <xsl:apply-templates select="section/title"/>
      </xsl:if>
      <xsl:apply-templates/>
    </book>
  </xsl:template>
  
  <!-- remove attributes and elements in CSS namespace -->
  <xsl:template match="css:*"/>
  
  <xsl:template match="@css:*"/>
  
  <!-- remove hub attributes -->
  <xsl:template match="@hub:*"/>
  
  <!-- remove hub prefix -->
  <xsl:template match="@role[. eq 'hub:identifier']">
    <xsl:attribute name="role" select="'identifier'"/>
  </xsl:template>
  
  <!-- in attributes only NM tokens are permitted, thus convert them to decimal codepoints -->
  <xsl:template match="@mark">
    <xsl:variable name="mark" select="if(string-length() eq 1 ) then concat('dec-', string-to-codepoints(.)) else ." as="xs:string"/>
    <xsl:attribute name="mark" select="$mark"/>
  </xsl:template> 
  
  <xsl:template match="/hub/section">
    <chapter>
      <xsl:apply-templates select="@*, node()"/>
    </chapter>
  </xsl:template>
    
  <!-- drop breaks and tabs -->
  <xsl:template match="br">
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="tab">
    <xsl:text>&#x9;</xsl:text>
  </xsl:template>
  
  <!-- patch filerefs -->
  <xsl:template match="imagedata/@fileref">
    <xsl:attribute name="fileref" select="concat(
      /hub/info/keywordset[@role eq 'hub']/keyword[@role eq 'source-dir-uri'],
      replace(., '^container:', '')
      )"/>
  </xsl:template>
  
  <!-- remove invalid structurs -->
  
  <xsl:template match="phrase[mediaobject]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="superscript[footnote]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="@renderas"/>
  
  <!-- identity template -->
  <xsl:template match="@*|*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>