<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:letex="http://www.le-tex.de/namespace"
  xmlns:hub2dbk="http://www.le-tex.de/namespace/hub2dbk"
  version="1.0"
  name="hub2dbk-convert"
  type="hub2dbk:convert">
  
  <p:documentation>
    This step expects a hub document and converts it to Docbook 5.0. Generally, the step
    drops hub-specific elements and CSS attributes.
  </p:documentation>
  
  <p:input port="source">
    <p:documentation>
      The source port expects a flat or evolved hub document.
    </p:documentation>
  </p:input>
	
  <p:output port="result">
    <p:documentation>
      The result port provides the converted docbook file.
    </p:documentation>
  </p:output>
  
  <p:option name="debug" select="'yes'"/> 
  <p:option name="debug-dir-uri" select="'debug'"/>
  
  <p:import href="http://transpect.le-tex.de/xproc-util/store-debug/store-debug.xpl"/>
  
  <p:xslt>
    <p:documentation>
      Drops hub-specific elements and attributes.
    </p:documentation>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/hub2docbook.xsl"/>
    </p:input>
  </p:xslt>
  
  <letex:store-debug pipeline-step="hub2dbk/hub2dbk">
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </letex:store-debug>
  
</p:declare-step>