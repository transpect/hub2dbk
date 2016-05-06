<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io"
  version="1.0"
  name="hub2dbk-convert"
  type="tr:hub2dbk">
  
  <p:documentation>
    This step expects a hub document and converts it to Docbook 5.0. Generally, the step
    drops hub-specific elements and CSS attributes.
  </p:documentation>
  
  <p:input port="source" primary="true">
    <p:documentation>
      The source port expects a flat or evolved hub document.
    </p:documentation>
  </p:input>
  
  <p:input port="stylesheet" primary="false">
    <p:documentation>
      XSLT stylesheet for dynamic hub2dbk conversion.
    </p:documentation>
    <p:document href="../xsl/hub2dbk.xsl"/>
  </p:input>
	
  <p:output port="result">
    <p:documentation>
      The result port provides the converted docbook file.
    </p:documentation>
  </p:output>
  
  <p:option name="debug" select="'yes'"/> 
  <p:option name="debug-dir-uri" select="'debug'"/>	
	<p:option name="status-dir-uri" select="'status'"/>
	
	<p:option name="top-level-element-name" select="'chapter'"/>
	
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
	<p:import href="http://transpect.io/xproc-util/simple-progress-msg/xpl/simple-progress-msg.xpl"/>
  
	<tr:simple-progress-msg file="hub2dbk-start.txt">
		<p:input port="msgs">
			<p:inline>
				<c:messages>
					<c:message xml:lang="en">Start Hub to Docbook conversion.</c:message>
					<c:message xml:lang="de">Beginne Konvertierung Hub nach Docbook.</c:message>
				</c:messages>
			</p:inline>
		</p:input>
		<p:with-option name="status-dir-uri" select="$status-dir-uri"/>
	</tr:simple-progress-msg>
  
  <p:xslt>
    <p:documentation>
      Drops hub-specific elements and attributes.
    </p:documentation>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="stylesheet" step="hub2dbk-convert"/>
    </p:input>
  	<p:with-param name="top-level-element-name" select="$top-level-element-name"/>
  </p:xslt>
  
  <tr:store-debug pipeline-step="hub2dbk/hub2dbk">
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
	
	<tr:simple-progress-msg file="hub2dbk-finished.txt">
		<p:input port="msgs">
			<p:inline>
				<c:messages>
					<c:message xml:lang="en">Successfully finished Hub to Docbook conversion.</c:message>
					<c:message xml:lang="de">Konvertierung Hub nach Docbook erfolgreich abgeschlossen.</c:message>
				</c:messages>
			</p:inline>
		</p:input>
		<p:with-option name="status-dir-uri" select="$status-dir-uri"/>
	</tr:simple-progress-msg>
  
</p:declare-step>