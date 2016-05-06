<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:hub="http://transpect.io/hub"
	xmlns:css="http://www.w3.org/1996/css" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs cx css hub xlink" xpath-default-namespace="http://docbook.org/ns/docbook" version="2.0">

	<xsl:param name="top-level-element-name" select="'chapter'" as="xs:string"/>

	<!--  *
        * remove top-level xml-model declarations
        * -->
	<xsl:template match="//processing-instruction()" priority="100"/>

	<!--  *
        * remove whitespace before root element
        * -->
	<xsl:template match="/text()"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/hub">
		<xsl:processing-instruction name="xml-model">href="http://docbook.org/xml/5.0/rng/docbook.rng" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
		<xsl:element name="{$top-level-element-name}">
			<xsl:if test="not(title | info/title)">
				<title/>	
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="phrase">
		<xsl:variable name="atts" as="attribute(*)*">
			<xsl:call-template name="emph-atts"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="count($atts[not(name() = 'srcpath')]) gt 0">
				<emphasis>
					<xsl:sequence select="$atts"/>
					<xsl:apply-templates/>
				</emphasis>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="emph-atts" as="attribute(*)*">
		<xsl:variable name="role" select="string-join((@css:font-style, @css:font-weight, @css:text-decoration-line), ' ')" as="xs:string?"/>
		<xsl:if test="$role">
			<xsl:attribute name="role" select="$role"/>
		</xsl:if>
		<xsl:apply-templates select="@* except (@css:font-style, @css:font-weight, @css:text-decoration-line)"/>
	</xsl:template>

	<!-- in attributes only NM tokens are permitted, thus convert them to decimal codepoints -->
	<xsl:template match="@mark">
		<xsl:variable name="mark" select="if(string-length() eq 1 ) then concat('dec-', string-to-codepoints(.)) else ."
			as="xs:string"/>
		<xsl:attribute name="mark" select="$mark"/>
	</xsl:template>

	<!-- patch filerefs -->

	<xsl:template match="imagedata/@fileref">
		<xsl:attribute name="fileref"
			select="if(matches(., '^container:')) then 
      concat(
      /hub/info/keywordset[@role eq 'hub']/keyword[@role eq 'source-dir-uri'],
      replace(., '^container:', '')
      )
      else ."
		/>
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

	<xsl:template match="@hub:*|@renderas"/>

	<xsl:template match="@role[. eq 'hub:identifier']">
	  <xsl:attribute name="role" select="'hub_identifier'"/>
	</xsl:template>

	<xsl:template match="br">
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="tabs">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tab">
		<xsl:text>&#x9;</xsl:text>
	</xsl:template>


	<xsl:template match="@* | node()" mode="cals2html-table">
		<xsl:copy copy-namespaces="yes">
			<xsl:apply-templates select="@*, node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="row" mode="cals2html-table">
		<tr>
			<xsl:apply-templates select="@*, node()" mode="#current"/>
		</tr>
	</xsl:template>

	<xsl:template match="tgroup" mode="cals2html-table">
		<colgroup>
			<xsl:for-each select="colspec">
				<col width="{@colwidth}"/>
			</xsl:for-each>
		</colgroup>
		<xsl:apply-templates select="node()" mode="#current"/>
	</xsl:template>

	<xsl:template match="tbody" mode="cals2html-table">
		<tbody>
			<xsl:apply-templates select="@*, node()" mode="#current"/>
		</tbody>
	</xsl:template>

	<xsl:template match="thead" mode="cals2html-table">
		<thead>
			<xsl:apply-templates select="@*, node()" mode="#current"/>
		</thead>
	</xsl:template>

	<xsl:template match="entry" mode="cals2html-table">
		<xsl:element name="{if (ancestor::thead) then 'th' else 'td'}">
			<xsl:if test="@namest">
				<!-- should be more robust than just relying on certain column name literals -->
				<xsl:attribute name="colspan"
					select="number(replace(@nameend, '^c(ol)?', '')) - number(replace(@namest, 'c(ol)?', '')) + 1"/>
			</xsl:if>
			<xsl:if test="@morerows &gt; 0">
				<xsl:attribute name="rowspan" select="@morerows + 1"/>
			</xsl:if>
			<!--<xsl:apply-templates select="@srcpath, @class, @style, @align, @valign" mode="#current"/>-->

			<xsl:apply-templates select="@*, node()" mode="#current"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="colspec" mode="cals2html-table"/>

	<xsl:template match="@nameend" mode="cals2html-table"/>
	<xsl:template match="@namest" mode="cals2html-table"/>
	<xsl:template match="@colname" mode="cals2html-table"/>
	<xsl:template match="@frame" mode="cals2html-table"/>

</xsl:stylesheet>
