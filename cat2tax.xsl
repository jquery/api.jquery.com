<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="category">
		<item>
			<name><xsl:value-of select="@name"/></name>
			<slug><xsl:value-of select="@slug"/></slug>
			<xsl:if test="desc/child::node()">
				<description><xsl:copy-of select="desc/text()|desc/*"/></description>
			</xsl:if>
			<xsl:if test="category">
				<children>
					<xsl:apply-templates select="category"/>
				</children>
			</xsl:if>
		</item>
	</xsl:template>

	<xsl:template match="categories">
		<category>
			<xsl:apply-templates select="node()"/>
		</category>
	</xsl:template>

</xsl:stylesheet>
