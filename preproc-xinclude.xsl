<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- IdentityTransform -->
  <!-- For more info, see http://www.usingxml.com/Transforms/XslIdentity or google 'identity xsl' -->
  <xsl:template match="/ | @* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Create note xinclude based on note id -> filename -->
  <xsl:template match="note">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
        <xi:include xmlns:xi="http://www.w3.org/2001/XInclude">
            <xsl:attribute name="href">../notes/<xsl:value-of select="@id"/>.xml</xsl:attribute>
        </xi:include>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>