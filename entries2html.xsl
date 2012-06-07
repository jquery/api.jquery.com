<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:template match="option|property">
    <h5 class="option">
      <xsl:value-of select="@name" />
      <xsl:if test="@added"> <span class="added">(added <xsl:value-of select="@added" />)</span></xsl:if>
      <xsl:if test="@deprecated"> <span class="deprecated">(deprecated <xsl:value-of select="@deprecated" />)</span></xsl:if>
      <xsl:if test="@removed"> <span class="removed">(removed <xsl:value-of select="@removed" />)</span></xsl:if>
      <span class="type">
        <a href="http://api.jquery.com/Types#{@type}"><xsl:value-of select="@type" /></a>
      </span>
    </h5>
    <xsl:if test="@default">
      <div class="default-value"><strong>Default: </strong> <xsl:value-of select="@default" /></div>
    </xsl:if>
    <p>
      <xsl:copy-of select="desc/text()|desc/*" />
    </p>
</xsl:template>


<xsl:template match="/">
  <xsl:variable name="dquo">"</xsl:variable>
  <xsl:variable name="squo">'</xsl:variable>
  <xsl:variable name="desc-raw" select="//entry/desc/text()|//entry/desc/*" />
  <xsl:variable name="desc-trans" select="translate($desc-raw, $dquo, $squo)" />

<script>
	{
		"title": "<xsl:value-of select="//entry/@name" />",
		"excerpt": "<xsl:copy-of select="$desc-trans" />",
		"termSlugs": {
			"category": [
				<xsl:for-each select="//entry/category"><xsl:if test="position() &gt; 1"><xsl:text>,</xsl:text></xsl:if>"<xsl:value-of select="@slug"/>"</xsl:for-each>
			]
		}
	}
</script>
<xsl:if test="count(//entry) &gt; 1">
<div class="toc">
  <h4><span>Contents:</span></h4>
  <ul class="toc-list">
    <xsl:for-each select="//entry">
      <xsl:variable name="entry-name" select="@name" />
      <xsl:variable name="entry-name-trans" select="translate($entry-name,'$., ()/{}','s---')" />
      <xsl:variable name="arg-num" select="count(signature[1]/argument)" />
      <li>
        <a href="#{concat($entry-name-trans,position())}">
        <xsl:value-of select="@name" /><xsl:if test="@type='method'">(<xsl:if test="signature/argument"><xsl:text> </xsl:text>
          <xsl:for-each select="signature[1]/argument">

            <xsl:if test="@optional">[<xsl:text>&#160;</xsl:text></xsl:if>
            <xsl:if test="position() &gt; 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="@name" />
            <xsl:if test="@optional"><xsl:text>&#160;</xsl:text>]</xsl:if>
            <xsl:text> </xsl:text>
            </xsl:for-each>
        <xsl:text>&#160;</xsl:text></xsl:if>)</xsl:if>
          <xsl:text> </xsl:text>
        </a>

      <xsl:if test="@type='method'">
          <ul>
            <xsl:for-each select="signature">
              <li>
                <xsl:variable name="method-sig-arg-num" select="count(argument)" />

                  <xsl:if test="not(contains($entry-name, '.')) and $entry-name != 'jQuery'">.</xsl:if><xsl:value-of select="$entry-name" />(<xsl:if test="argument"><xsl:text> </xsl:text>
                    <xsl:for-each select="argument">
                    <xsl:if test="@optional"> [</xsl:if>
                      <xsl:if test="position() &gt; 1">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                      <xsl:value-of select="@name" />
                    <xsl:if test="@optional">] </xsl:if>
                    </xsl:for-each><xsl:text> </xsl:text></xsl:if>)
              </li>
            </xsl:for-each>
          </ul>
      </xsl:if>
      </li>
    </xsl:for-each>
  </ul>
</div>
</xsl:if>

<xsl:for-each select="//entry">
  <xsl:variable name="entry-name" select="@name" />
  <xsl:variable name="entry-name-trans" select="translate($entry-name,'$., ()/{}','s---')" />
  <xsl:variable name="entry-type" select="@type" />
  <xsl:variable name="plugin-name" select="@plugin" />
  <xsl:variable name="entry-index" select="position()" />
  <xsl:variable name="number-examples" select="count(example)" />
  <xsl:variable name="entry-pos" select="concat($entry-name-trans,$entry-index)" />

  <div>
    <xsl:attribute name="id">
      <xsl:value-of select="$entry-pos"></xsl:value-of>
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$plugin-name">
          <xsl:value-of select="concat('entry plugin ', $entry-type)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('entry ', $entry-type)" />
        </xsl:otherwise>
      </xsl:choose>

    </xsl:attribute>
  <h2 class="jq-clearfix roundTop section-title">
    <span class="name">
      <xsl:choose>
        <xsl:when test="$entry-type='method'"><xsl:if test="not(contains($entry-name, '.')) and not(contains($entry-name, '{')) and $entry-name != 'jQuery'">.</xsl:if></xsl:when>
      </xsl:choose>
      <xsl:value-of select="@name" /><xsl:if test="@type='method'">(<xsl:if test="signature/argument"><xsl:text> </xsl:text>
      <xsl:variable name="sig-arg-num" select="count(signature[1]/argument)" />

      <xsl:for-each select="signature[1]/argument">
        <xsl:if test="@optional"> [</xsl:if>
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="@name" />
        <xsl:if test="@optional">] </xsl:if>
      </xsl:for-each>
      <xsl:text> </xsl:text></xsl:if>)</xsl:if>
    </span>
    <xsl:text> </xsl:text>

    <xsl:choose>
      <xsl:when test="$entry-type='selector'">
        <xsl:text> selector</xsl:text>
      </xsl:when>
      <xsl:otherwise>

        <span class="returns">
          <xsl:if test="@return != ''">Returns: <a class="return" href="http://api.jquery.com/Types/#{@return}"><xsl:value-of select="@return" /></a></xsl:if>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </h2>
  <div class="jq-box roundBottom entry-details">
    <xsl:choose>
      <xsl:when test="$entry-type='selector'">
        <xsl:if test="./sample">
          <h4 class="name">
            <xsl:if test="./signature/added">
              <span class="versionAdded">version added: <a href="/category/version/{signature/added}/"><xsl:value-of select="signature/added" /></a></span>
            </xsl:if>
            <xsl:if test="./signature/deprecated">
              <span class="version-deprecated">version deprecated: <a href="/category/version/{signature/deprecated}/"><xsl:value-of select="signature/deprecated" /></a></span>
            </xsl:if>
            <xsl:if test="./signature/removed">
              <span class="version-removed">version removed: <a href="/category/version/{signature/removed}/"><xsl:value-of select="signature/removed" /></a></span>
            </xsl:if>
            <xsl:text>jQuery('</xsl:text><xsl:value-of select="sample" /><xsl:text>')</xsl:text>
          </h4>
        </xsl:if>
        <xsl:if test="signature/argument">
          <ul class="signatures">
            <li>
              <dl class="arguments">
                <xsl:for-each select="signature/argument">
                  <dt><xsl:value-of select="@name" /></dt>
                  <dd><xsl:copy-of select="desc/text()|desc/*" /></dd>
                </xsl:for-each>
              </dl>
            </li>
          </ul>
        </xsl:if>
        <p class="desc"><strong>Description: </strong> <xsl:value-of select="desc" /></p>
      </xsl:when>
      <xsl:otherwise>

      <p class="desc"><strong>Description: </strong> <xsl:value-of select="desc" /></p>
        <ul class="signatures">
          <xsl:for-each select="signature">
            <li class="signature">
              <xsl:attribute name="id">
                <xsl:value-of select="$entry-name-trans" />
                <xsl:for-each select="argument">
                  <xsl:variable name="arg-name" select="translate(@name, ' ,.)(', '--')" />
                  <xsl:text>-</xsl:text><xsl:value-of select="$arg-name"/>
                </xsl:for-each>
              </xsl:attribute>
              <h4 class="name">
                <xsl:if test="./added">
                  <span class="versionAdded">version added: <a href="/category/version/{added}/"><xsl:value-of select="added" /></a></span>
                </xsl:if>
                <xsl:if test="$entry-type='method'"><xsl:if test="not(contains($entry-name, '.')) and $entry-name != 'jQuery'">.</xsl:if></xsl:if><xsl:value-of select="$entry-name" /><xsl:if test="$entry-type='method'">(<xsl:if test="argument"><xsl:text> </xsl:text>
                <xsl:variable name="desc-arg-num" select="count(argument)" />

                  <xsl:for-each select="argument">
                    <xsl:if test="@optional"> [</xsl:if>

                    <xsl:if test="position() &gt; 1">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="@name" />
                    <xsl:if test="@optional">]</xsl:if>

                  </xsl:for-each>
                <xsl:text> </xsl:text></xsl:if>)</xsl:if>
              </h4>
              <xsl:if test="argument">
                  <xsl:for-each select="argument">
                    <p class="argument"><strong><xsl:value-of select="@name" /> </strong> <xsl:copy-of select="desc/text()|desc/*" /></p>
                    <xsl:if test="option">
                      <div class="options">
                        <xsl:apply-templates select="option"/>
                      </div>
                    </xsl:if>
                  </xsl:for-each>
              </xsl:if>
              <xsl:if test="option|property">
                <div class="options">
                  <xsl:apply-templates select="option|property"/>
                </div>
              </xsl:if>
            </li>

          </xsl:for-each>
        </ul>

      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="normalize-space(download/*)">
      <div class="download">
        <xsl:copy-of select="download/*" />
      </div>
    </xsl:if>

    <xsl:if test="normalize-space(longdesc/*)">
      <div class="longdesc">
        <xsl:copy-of select="longdesc/*" />
      </div>
    </xsl:if>
    <xsl:if test="$number-examples &gt; 0">
      <h3>Example<xsl:if test="$number-examples &gt; 1">s</xsl:if>:</h3>
      <div class="entry-examples">
        <xsl:attribute name="id">
          <xsl:text>entry-examples</xsl:text>
            <xsl:if test="$entry-index &gt; 1">
              <xsl:text>-</xsl:text><xsl:value-of select="$entry-index - 1"/>
            </xsl:if>
        </xsl:attribute>
      <xsl:for-each select="example">
        <div>
          <xsl:attribute name="id">
            <xsl:text>example-</xsl:text>
            <xsl:if test="$entry-index &gt; 1">
              <xsl:value-of select="$entry-index - 1"/>
              <xsl:text>-</xsl:text>
            </xsl:if>
            <xsl:value-of select="position() - 1"/>
          </xsl:attribute>
          <h4><xsl:if test="$number-examples &gt; 1">Example: </xsl:if><span class="desc"><xsl:value-of select="desc" /></span></h4>
  <pre><code data-linenos="true"><xsl:choose>
            <xsl:when test="html">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;<xsl:if test="css/text()">
  &lt;style&gt;<xsl:copy-of select="css/text()" />&lt;/style&gt;</xsl:if>
  <xsl:choose>
    <xsl:when test="count(js)">
    <xsl:for-each select="js">
  &lt;script src="<xsl:value-of select="@src" />"&gt;&lt;/script&gt;</xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
  &lt;script src="http://code.jquery.com/jquery-latest.js"&gt;&lt;/script&gt;</xsl:otherwise></xsl:choose><xsl:if test="code/@location='head'">
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
&lt;/html&gt;</xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">example</xsl:attribute>
            <xsl:copy-of select="code/text()" />
          </xsl:otherwise>
        </xsl:choose></code></pre>
        <xsl:if test="html">
          <h4>Demo:</h4>
          <div><xsl:choose>
            <xsl:when test="html">
              <xsl:attribute name="class">demo code-demo</xsl:attribute>
              <xsl:if test="height">
                <xsl:attribute name="rel"><xsl:value-of select="height"/></xsl:attribute>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">demo</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        </xsl:if>
        <xsl:if test="results">
          <h4>Result:</h4>
          <pre>
            <code class="results">
              <xsl:value-of select="results"/>
            </code>
          </pre>
        </xsl:if>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </div>
</div>

</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
