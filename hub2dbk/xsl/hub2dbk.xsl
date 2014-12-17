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
  
  <xsl:variable name="multiple-top-level-headlines" select="count(/hub/section) gt 1" as="xs:boolean"/>
  
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
    <!-- rename hub to book element, drop atts except @xml:base -->
    <xsl:choose>
      <xsl:when test="$multiple-top-level-headlines">
        <book>
          <xsl:apply-templates select="@*, 
            /hub/info
            /hub/section[1]/title,
            node() except (/hub/section[1]/title[1])
            "/>
        </book>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="* except info"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/hub/section">
    <xsl:choose>
      <xsl:when test="$multiple-top-level-headlines">
        <book>
          <xsl:apply-templates select="/hub/@xml:base, @*, node()"/>
        </book>
      </xsl:when>
      <xsl:otherwise>
        <book>
          <xsl:apply-templates select="title, /hub/info, node() except title"/>  
        </book>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/hub/section/section">
    <xsl:element name="{if($multiple-top-level-headlines) then 'section' else 'chapter'}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="phrase">
    <emphasis role="{(@css:font-style, @css:font-weight, @css:text-decoration-line)[1]}">
      <xsl:apply-templates select="@*, node()"/>
    </emphasis>
  </xsl:template>
  
  <!-- in attributes only NM tokens are permitted, thus convert them to decimal codepoints -->
  <xsl:template match="@mark">
    <xsl:variable name="mark" select="if(string-length() eq 1 ) then concat('dec-', string-to-codepoints(.)) else ." as="xs:string"/>
    <xsl:attribute name="mark" select="$mark"/>
  </xsl:template>
  
  <!-- patch filerefs -->
  
  <xsl:template match="imagedata/@fileref">
    <xsl:attribute name="fileref" select="if(matches(., '^container:')) then 
      concat(
      /hub/info/keywordset[@role eq 'hub']/keyword[@role eq 'source-dir-uri'],
      replace(., '^container:', '')
      )
      else ."/>
  </xsl:template>
  
  <!-- identity template -->
  <xsl:template match="@*|*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--  *
        * DROP Hub-specific markup
        * -->
  
  <xsl:template match="css:*|@css:*"/>
  
  <xsl:template match="@hub:*|@renderas|@srcpath"/>  
  
  <xsl:template match="@role[. eq 'hub:identifier']">
    <xsl:attribute name="role" select="'identifier'"/>
  </xsl:template>  
  
  <xsl:template match="br">
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="tab">
    <xsl:text>&#x9;</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>