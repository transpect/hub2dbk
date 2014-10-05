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
	<p:option name="progress" select="concat($debug-dir-uri, '/status')"/>
	<p:option name="status-dir-uri" select="concat($debug-dir-uri, '/status')"/>
	
  <p:import href="http://transpect.le-tex.de/xproc-util/store-debug/store-debug.xpl"/>
  
	<letex:simple-progress-msg file="hub2dbk-start.txt">
		<p:input port="msgs">
			<p:inline>
				<c:messages>
					<c:message xml:lang="en">Start Hub to Docbook conversion.</c:message>
					<c:message xml:lang="de">Beginne Konvertierung Hub nach Docbook.</c:message>
				</c:messages>
			</p:inline>
		</p:input>
		<p:with-option name="status-dir-uri" select="$status-dir-uri"/>
	</letex:simple-progress-msg>
  
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
	
	<letex:simple-progress-msg file="hub2dbk-finished.txt">
		<p:input port="msgs">
			<p:inline>
				<c:messages>
					<c:message xml:lang="en">Successfully finished Hub to Docbook conversion.</c:message>
					<c:message xml:lang="de">Konvertierung Hub nach Docbook erfolgreich abgeschlossen.</c:message>
				</c:messages>
			</p:inline>
		</p:input>
		<p:with-option name="status-dir-uri" select="$status-dir-uri"/>
	</letex:simple-progress-msg>
  
</p:declare-step>