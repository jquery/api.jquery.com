<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="node_modules/grunt-jquery-content/tasks/jquery-xml/entries2html-base.xsl"/>
<xsl:import href="notes.xsl"/>

<xsl:variable name="version-category-links" select="true()"/>

<xsl:template name="example-code">
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;<xsl:if test="css/text()">
	&lt;style&gt;<xsl:copy-of select="css/text()" />&lt;/style&gt;</xsl:if>
	&lt;script src="http://code.jquery.com/jquery-1.9.1.js"&gt;&lt;/script&gt;<xsl:if test="code/@location='head'">
	&lt;script&gt;
	<xsl:copy-of select="code/text()" />
	&lt;/script&gt;
</xsl:if>
&lt;/head&gt;
&lt;body&gt;
	<xsl:copy-of select="html/text()" />
<xsl:choose>
	<xsl:when test="code/@location='head'"></xsl:when>
	<xsl:otherwise>
&lt;script&gt;<xsl:copy-of select="code/text()" />&lt;/script&gt;</xsl:otherwise>
</xsl:choose>

&lt;/body&gt;
&lt;/html&gt;
</xsl:template>

</xsl:stylesheet>
