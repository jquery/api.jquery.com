<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="node_modules/grunt-jquery-content/tasks/jquery-xml/entries2html-base.xsl"/>
<xsl:import href="notes.xsl"/>

<xsl:variable name="version-category-links" select="true()"/>

<xsl:template name="example-code">
&lt;!doctype html&gt;
&lt;html lang="en"&gt;
&lt;head&gt;
	&lt;meta charset="utf-8"&gt;
	&lt;title&gt;<xsl:value-of select="//entry/@name"/> demo&lt;/title&gt;<xsl:if test="css">
	&lt;style&gt;<xsl:value-of select="css/text()"/>	&lt;/style&gt;</xsl:if>
	&lt;script src="//code.jquery.com/jquery-1.10.2.js"&gt;&lt;/script&gt;<xsl:if test="code/@location='head'">
	&lt;script&gt;
	<xsl:copy-of select="code/text()"/>
	&lt;/script&gt;
</xsl:if>
&lt;/head&gt;
&lt;body&gt;
	<xsl:copy-of select="html/text()"/>
<xsl:choose>
	<xsl:when test="code/@location='head'"></xsl:when>
	<xsl:otherwise>
&lt;script&gt;<xsl:copy-of select="code/text()"/>&lt;/script&gt;</xsl:otherwise>
</xsl:choose>

&lt;/body&gt;
&lt;/html&gt;
</xsl:template>

</xsl:stylesheet>
