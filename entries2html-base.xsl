<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" omit-xml-declaration="yes"/>

<!-- Set this to true to display links to /category/version/{version} -->
<xsl:variable name="version-category-links" select="false()"/>

<xsl:template match="/">
	<script>{
		"title":
			<xsl:call-template name="escape-string">
				<xsl:with-param name="s" select="//entry/title/text()"/>
			</xsl:call-template>,
		"excerpt":
			<xsl:call-template name="escape-string">
				<xsl:with-param name="s" select="//entry[1]/desc/text()|//entry[1]/desc/*"/>
			</xsl:call-template>,
		"termSlugs": {
			"category": [
				<xsl:for-each select="//entry/category">
					<xsl:if test="position() &gt; 1"><xsl:text>,</xsl:text></xsl:if>
					<xsl:text>"</xsl:text>
					<xsl:value-of select="@slug"/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
			]
		}
	}</script>

	<xsl:if test="count(//entry) &gt; 1">
		<xsl:call-template name="toc"/>
	</xsl:if>

	<xsl:for-each select="//entry">
		<xsl:variable name="entry-name" select="@name"/>
		<xsl:variable name="entry-name-trans" select="translate($entry-name,'$., ()/{}','s---')"/>
		<xsl:variable name="entry-type" select="@type"/>
		<xsl:variable name="entry-index" select="position()"/>
		<xsl:variable name="entry-pos" select="concat($entry-name-trans,$entry-index)"/>
		<xsl:variable name="number-examples" select="count(example)"/>

		<xsl:if test="./added">
			<span class="versionAdded">version added: <xsl:value-of select="added"/></span>
		</xsl:if>

		<article>
			<xsl:attribute name="id">
				<xsl:value-of select="$entry-pos"/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('entry ', $entry-type)"/>
			</xsl:attribute>

			<xsl:call-template name="entry-title"/>
			<div class="entry-wrapper">
				<xsl:call-template name="entry-body"/>

				<xsl:if test="normalize-space(longdesc/*)">
					<div class="longdesc">
						<xsl:apply-templates select="longdesc"/>
					</div>
				</xsl:if>

				<xsl:if test="note">
					<h3>Additional Notes:</h3>
					<div class="longdesc">
						<ul>
							<xsl:for-each select="note">
								<li><xsl:call-template name="note"/></li>
							</xsl:for-each>
						</ul>
					</div>
				</xsl:if>

				<xsl:if test="example">
					<section class="entry-examples">
						<xsl:attribute name="id">
							<xsl:text>entry-examples</xsl:text>
							<xsl:if test="$entry-index &gt; 1">
								<xsl:text>-</xsl:text><xsl:value-of select="$entry-index - 1"/>
							</xsl:if>
						</xsl:attribute>

						<header>
							<h2 class="underline">Example<xsl:if test="$number-examples &gt; 1">s</xsl:if>:</h2>
						</header>

						<xsl:apply-templates select="example">
							<xsl:with-param name="entry-index" select="$entry-index"/>
							<xsl:with-param name="number-examples" select="$number-examples"/>
						</xsl:apply-templates>
					</section>
				</xsl:if>
			</div>
		</article>
	</xsl:for-each>
</xsl:template>

<xsl:template name="toc">
	<div class="toc">
		<h4><span>Contents:</span></h4>
		<ul class="toc-list">
			<xsl:for-each select="//entry">
				<xsl:variable name="entry-name-trans" select="translate(@name,'$., ()/{}','s---')" />
				<xsl:variable name="entry-url" select="concat('#',$entry-name-trans,position())"/>
				<xsl:choose>
					<xsl:when test="@type='method'">
						<xsl:call-template name="toc-method">
							<xsl:with-param name="entry-url" select="$entry-url"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="toc-basic">
							<xsl:with-param name="entry-url" select="$entry-url"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ul>
	</div>
</xsl:template>

<xsl:template name="toc-basic">
	<xsl:param name="entry-url"/>
	<li><a href="{$entry-url}"><xsl:value-of select="@name"/></a></li>
</xsl:template>

<xsl:template name="toc-method">
	<xsl:param name="entry-url"/>
	<xsl:variable name="entry-name" select="@name"/>

	<li>
		<a href="{$entry-url}">
			<xsl:for-each select="signature[1]">
				<xsl:call-template name="method-signature">
					<xsl:with-param name="method-name" select="$entry-name"/>
					<xsl:with-param name="dot" select="true()"/>
				</xsl:call-template>
			</xsl:for-each>
		</a>

		<ul>
			<xsl:for-each select="signature">
				<li>
					<xsl:call-template name="method-signature">
						<xsl:with-param name="method-name" select="$entry-name"/>
						<xsl:with-param name="dot" select="true()"/>
					</xsl:call-template>
				</li>
			</xsl:for-each>
		</ul>
	</li>
</xsl:template>

<xsl:template name="entry-title">
	<xsl:param name="entry-type" select="@type"/>
	<xsl:param name="entry-name" select="@name"/>

	<h2 class="section-title">
		<xsl:choose>
			<xsl:when test="$entry-type='method'">
				<span class="name">
					<xsl:for-each select="signature[1]">
						<xsl:call-template name="method-signature">
							<xsl:with-param name="method-name" select="$entry-name"/>
							<xsl:with-param name="dot" select="true()"/>
						</xsl:call-template>
					</xsl:for-each>
				</span>
				<xsl:call-template name="return-value"/>
			</xsl:when>
			<xsl:when test="$entry-type='selector'">
				<span>
					<xsl:value-of select="@name"/>
					<xsl:text> selector</xsl:text>
				</span>
			</xsl:when>
			<xsl:when test="$entry-type='property'">
				<span>
					<xsl:value-of select="@name"/>
				</span>
				<xsl:call-template name="return-value"/>
			</xsl:when>
			<xsl:otherwise>
				<span><xsl:value-of select="title"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</h2>
</xsl:template>

<xsl:template name="entry-body">
	<p class="desc"><strong>Description: </strong> <xsl:value-of select="desc"/></p>
	<xsl:choose>
		<xsl:when test="@type='selector'">
			<xsl:call-template name="entry-body-selector"/>
		</xsl:when>
		<xsl:when test="@type='property'">
			<xsl:call-template name="entry-body-property"/>
		</xsl:when>
		<xsl:when test="@type='method'">
			<xsl:call-template name="entry-body-method"/>
		</xsl:when>
		<xsl:when test="@type='widget'">
			<xsl:call-template name="entry-body-widget"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="entry-body-selector">
	<ul class="signatures">
		<li class="signature">
			<h4 class="name">
				<xsl:if test="signature/added">
					<span class="versionAdded">
						version added:
						<a href="/category/version/{signature/added}/">
							<xsl:value-of select="signature/added"/>
						</a>
					</span>
				</xsl:if>
				<xsl:text>jQuery( "</xsl:text><xsl:value-of select="sample"/><xsl:text>" )</xsl:text>
			</h4>

			<xsl:for-each select="signature/argument">
				<p class="argument">
					<strong><xsl:value-of select="@name"/>: </strong>
					<xsl:copy-of select="desc/text()|desc/*"/>
				</p>
			</xsl:for-each>
		</li>
	</ul>
</xsl:template>

<xsl:template name="entry-body-property">
	<ul class="signatures">
		<li class="signature">
			<h4 class="name">
				<xsl:if test="signature/added">
					<span class="versionAdded">
						version added:
						<a href="/category/version/{signature/added}/">
							<xsl:value-of select="added"/>
						</a>
					</span>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</h4>
		</li>
	</ul>
</xsl:template>

<xsl:template name="entry-body-method">
	<xsl:variable name="entry-name" select="@name"/>
	<xsl:variable name="entry-name-trans" select="translate($entry-name,'$., ()/{}','s---')"/>

	<ul class="signatures">
		<xsl:for-each select="signature">
			<li class="signature">
				<xsl:attribute name="id">
					<xsl:value-of select="$entry-name-trans"/>
					<xsl:for-each select="argument">
						<xsl:variable name="arg-name" select="translate(@name, ' ,.)(', '--')"/>
						<xsl:text>-</xsl:text><xsl:value-of select="$arg-name"/>
					</xsl:for-each>
				</xsl:attribute>

				<h4 class="name">
					<xsl:if test="./added">
						<span class="versionAdded">
							version added:
							<a href="/category/version/{added}/">
								<xsl:value-of select="added"/>
							</a>
						</span>
					</xsl:if>
					<xsl:call-template name="method-signature">
						<xsl:with-param name="method-name" select="$entry-name"/>
						<xsl:with-param name="dot" select="true()"/>
					</xsl:call-template>
				</h4>

				<xsl:call-template name="arguments"/>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>

<xsl:template name="entry-body-widget">
	<xsl:variable name="entry-name" select="@name"/>

	<xsl:if test="options">
		<section id="options">
			<header>
				<h2 class="underline">Options</h2>
			</header>
			<xsl:for-each select="options/option">
				<xsl:sort select="@name"/>
				<div id="option-{@name}">
					<h3>
						<xsl:value-of select="@name"/>
					</h3>
					<div>
						<strong>Type: </strong>
						<xsl:call-template name="render-types"/>
					</div>
					<div>
						<strong>Default: </strong>
						<code><xsl:value-of select="@default"/></code>
					</div>
					<div>
						<xsl:apply-templates select="desc">
							<xsl:with-param name="entry-name" select="$entry-name"/>
						</xsl:apply-templates>
						<xsl:call-template name="version-details"/>
					</div>
					<xsl:if test="type/desc">
						<strong>Multiple types supported:</strong>
						<ul>
							<xsl:for-each select="type/desc">
								<li>
									<strong><xsl:value-of select="../@name"/></strong>
									<xsl:text>: </xsl:text>
									<xsl:apply-templates select="."/>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:if>
					<xsl:apply-templates select="example">
						<xsl:with-param name="number-examples" select="count(example)"/>
					</xsl:apply-templates>
				</div>
			</xsl:for-each>
		</section>
	</xsl:if>
	<xsl:if test="methods">
		<section id="methods">
			<header>
				<h2 class="underline">Methods</h2>
			</header>
			<xsl:for-each select="methods/method">
				<xsl:sort select="@name"/>
				<xsl:variable name="method-name" select="@name"/>
				<div id="method-{$method-name}">
					<xsl:for-each select="signature | self::node()[count(signature) = 0]">
						<xsl:call-template name="widget-method-event">
							<xsl:with-param name="entry-name" select="$entry-name"/>
							<xsl:with-param name="method-name" select="$method-name"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
			</xsl:for-each>
		</section>
	</xsl:if>
	<xsl:if test="events">
		<section id="events">
			<header>
				<h2 class="underline">Events</h2>
			</header>
			<xsl:for-each select="events/event">
				<xsl:sort select="@name"/>
				<div id="event-{@name}">
					<xsl:call-template name="widget-method-event">
						<xsl:with-param name="entry-name" select="$entry-name"/>
						<xsl:with-param name="method-name" select="@name"/>
					</xsl:call-template>
				</div>
			</xsl:for-each>
		</section>
	</xsl:if>
</xsl:template>

<!-- examples -->
<xsl:template match="example">
	<xsl:param name="entry-index"/>
	<xsl:param name="number-examples"/>

	<div class="entry-example">
		<xsl:attribute name="id">
			<xsl:text>example-</xsl:text>
			<xsl:if test="$entry-index &gt; 1">
				<xsl:value-of select="$entry-index - 1"/>
				<xsl:text>-</xsl:text>
			</xsl:if>
			<xsl:value-of select="position() - 1"/>
		</xsl:attribute>

		<h4>
			<xsl:if test="$number-examples &gt; 1">Example: </xsl:if>
			<span class="desc"><xsl:value-of select="desc"/></span>
		</h4>
		<pre><code data-linenum="true">
			<xsl:choose>
				<xsl:when test="html">
					<xsl:call-template name="example-code"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="code/text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</code></pre>

		<xsl:if test="html">
			<h4>Demo:</h4>
			<div class="demo code-demo">
				<xsl:if test="height">
					<xsl:attribute name="data-height">
						<xsl:value-of select="height"/>
					</xsl:attribute>
				</xsl:if>
			</div>
		</xsl:if>

		<xsl:if test="results">
			<h4>Result:</h4>
			<pre><code class="results">
				<xsl:value-of select="results"/>
			</code></pre>
		</xsl:if>
	</div>
</xsl:template>
<xsl:template name="example-code"/>

<!--
	Render type(s) for an argument element.
	Type can either be a @type attribute or one or more <type> child elements.
-->
<xsl:template name="render-types">
	<xsl:if test="@type and type">
		<strong>ERROR: Use <i>either</i> @type or type elements</strong>
	</xsl:if>

	<!-- a single type -->
	<xsl:if test="@type">
		<xsl:call-template name="render-type">
			<xsl:with-param name="typename" select="@type" />
		</xsl:call-template>
	</xsl:if>

	<!-- elements. Render each type, comma seperated -->
	<xsl:if test="type">
		<xsl:for-each select="type">
			<xsl:if test="position() &gt; 1">, </xsl:if>
			<xsl:call-template name="render-type">
				<xsl:with-param name="typename" select="@name" />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<!-- Render a single type -->
<xsl:template name="render-type">
	<xsl:param name="typename"/>
	<xsl:choose>
	<!--
		If the type is "Function" we special case and write the function signature,
		e.g. function(String)=>String
		- formal arguments are child elements to the current element
		- the return element is optional
	-->
	<xsl:when test="$typename = 'Function'">
		<a href="http://api.jquery.com/Types/#Function">Function</a>
		<xsl:text>(</xsl:text>
		<xsl:if test="argument">
			<xsl:text> </xsl:text>
			<xsl:for-each select="argument">
				<xsl:if test="position() &gt; 1">, </xsl:if>
				<xsl:value-of select="@name"/>
				<xsl:text>: </xsl:text>
				<xsl:call-template name="render-types"/>
			</xsl:for-each>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:text>)</xsl:text>

		<!-- display return type if present -->
		<xsl:if test="return or @return">
			=>
			<xsl:call-template name="render-return-types" />
		</xsl:if>
	</xsl:when>
	<xsl:otherwise>
		<!-- not function - just display typename -->
		<a href="http://api.jquery.com/Types#{$typename}"><xsl:value-of select="$typename" /></a>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="render-return-types">
	<xsl:if test="@return and return">
		<strong>ERROR: Use <i>either</i> @return or return element</strong>
	</xsl:if>

	<!-- return attribute -->
	<xsl:if test="@return">
		<xsl:call-template name="render-type">
			<xsl:with-param name="typename" select="@return" />
		</xsl:call-template>
	</xsl:if>

	<!-- a return element -->
	<xsl:if test="return">
		<xsl:for-each select="return">
			<xsl:if test="position() &gt; 1">
				<strong>ERROR: A single return element is expected</strong>
			</xsl:if>
			<xsl:call-template name="render-types" />
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="return-value">
	<xsl:if test="@return != ''">
		<xsl:text> </xsl:text>
		<span class="returns">
			<xsl:text>Returns: </xsl:text>
			<a class="return" href="http://api.jquery.com/Types/#{@return}">
				<xsl:value-of select="@return"/>
			</a>
		</span>
	</xsl:if>
</xsl:template>

<xsl:template name="method-signature">
	<xsl:param name="method-name"/>
	<xsl:param name="dot" select="false()"/>

	<xsl:if test="$dot and not(contains($method-name, '.')) and $method-name != 'jQuery'">.</xsl:if>
	<xsl:value-of select="$method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:if test="argument">
		<xsl:text> </xsl:text>
		<xsl:for-each select="argument">
			<xsl:if test="@optional"> [</xsl:if>
			<xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
			<xsl:value-of select="@name"/>
			<xsl:if test="@optional"><xsl:text> ]</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:text>)</xsl:text>
</xsl:template>

<xsl:template name="arguments">
	<xsl:if test="argument">
		<ul>
			<xsl:apply-templates select="argument"/>
		</ul>
	</xsl:if>
</xsl:template>
<!-- arguments and properties are rendered the same way and nest -->
<xsl:template match="argument|property">
	<li>
		<div>
			<strong><xsl:value-of select="@name"/></strong>
			<xsl:if test="@default"> (default: <xsl:value-of select="@default"/>)</xsl:if>
		</div>
		<div>Type: <xsl:call-template name="render-types"/></div>
		<div>
			<xsl:apply-templates select="desc"/>
			<xsl:call-template name="version-details"/>
		</div>
		<xsl:if test="property">
			<ul>
				<xsl:apply-templates select="property"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template name="version-details">
	<xsl:if test="@added">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="$version-category-links">
				<strong>(added <a href="/category/version/{@added}/">
					<xsl:value-of select="@added"/>
				</a>)</strong>
			</xsl:when>
			<xsl:otherwise>
				<strong>(added <xsl:value-of select="@added"/>)</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="@deprecated">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="$version-category-links">
				<strong>(deprecated <a href="/category/version/{@deprecated}/">
					<xsl:value-of select="@deprecated"/>
				</a>)</strong>
			</xsl:when>
			<xsl:otherwise>
				<strong>(deprecated <xsl:value-of select="@deprecated"/>)</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="@removed">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="$version-category-links">
				<strong>(removed <a href="/category/version/{@removed}/">
					<xsl:value-of select="@removed"/>
				</a>)</strong>
			</xsl:when>
			<xsl:otherwise>
				<strong>(removed <xsl:value-of select="@removed"/>)</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template name="widget-method-event">
	<xsl:param name="entry-name"/>
	<xsl:param name="method-name"/>

	<h3>
		<xsl:call-template name="method-signature">
			<xsl:with-param name="method-name" select="$method-name"/>
		</xsl:call-template>
		<xsl:call-template name="return-value"/>
	</h3>
	<div>
		<xsl:apply-templates select="desc">
			<xsl:with-param name="entry-name" select="$entry-name"/>
		</xsl:apply-templates>
		<xsl:call-template name="version-details"/>
	</div>
	<xsl:call-template name="arguments"/>
</xsl:template>

<!-- <desc> and <longdesc> support <placeholder name="foo"> to replace the
placeholder with @foo from the <entry> -->
<xsl:template match="desc|longdesc">
	<xsl:param name="entry-name"/>
	<xsl:apply-templates select="./node()">
		<xsl:with-param name="entry-name" select="$entry-name"/>
	</xsl:apply-templates>
</xsl:template>
<!-- This makes elements and attributes get copied over properly -->
<xsl:template match="desc//*|desc//@*|longdesc//*|longdesc//@*">
	<xsl:copy>
		<xsl:apply-templates select="@* | node()"/>
	</xsl:copy>
</xsl:template>
<!-- <xi:include> will add an xml:base attribute, so we strip it out -->
<xsl:template match="//@xml:base"/>
<!-- replace the <placeholder> with the associated attribute from the entry -->
<xsl:template match="//placeholder">
	<xsl:variable name="name" select="@name"/>
	<xsl:value-of select="ancestor::entry/@*[name()=$name]"/>
</xsl:template>

<!-- escape-string, from xml2json.xsl -->
<xsl:template name="escape-string"><xsl:param name="s"/><xsl:text>"</xsl:text><xsl:call-template name="escape-bs-string"><xsl:with-param name="s" select="$s"/></xsl:call-template><xsl:text>"</xsl:text></xsl:template><xsl:template name="escape-bs-string"><xsl:param name="s"/><xsl:choose><xsl:when test="contains($s,'\')"><xsl:call-template name="escape-quot-string"><xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/></xsl:call-template><xsl:call-template name="escape-bs-string"><xsl:with-param name="s" select="substring-after($s,'\')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="escape-quot-string"><xsl:with-param name="s" select="$s"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:template><xsl:template name="escape-quot-string"><xsl:param name="s"/><xsl:choose><xsl:when test="contains($s,'&quot;')"><xsl:call-template name="encode-string"><xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/></xsl:call-template><xsl:call-template name="escape-quot-string"><xsl:with-param name="s" select="substring-after($s,'&quot;')"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="encode-string"><xsl:with-param name="s" select="$s"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:template><xsl:template name="encode-string"><xsl:param name="s"/><xsl:choose><!-- tab --><xsl:when test="contains($s,'&#x9;')"><xsl:call-template name="encode-string"><xsl:with-param name="s" select="concat(substring-before($s,'&#x9;'),'\t',substring-after($s,'&#x9;'))"/></xsl:call-template></xsl:when><!-- line feed --><xsl:when test="contains($s,'&#xA;')"><xsl:call-template name="encode-string"><xsl:with-param name="s" select="concat(substring-before($s,'&#xA;'),'\n',substring-after($s,'&#xA;'))"/></xsl:call-template></xsl:when><!-- carriage return --><xsl:when test="contains($s,'&#xD;')"><xsl:call-template name="encode-string"><xsl:with-param name="s" select="concat(substring-before($s,'&#xD;'),'\r',substring-after($s,'&#xD;'))"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise></xsl:choose></xsl:template>

</xsl:stylesheet>
